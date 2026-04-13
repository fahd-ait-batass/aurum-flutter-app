import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aurum_backend/src/aurum_backend_store.dart';
import 'package:aurum_backend/src/config/backend_runtime_config.dart';
import 'package:aurum_backend/src/http/api_exception.dart';
import 'package:aurum_backend/src/http/api_response.dart';
import 'package:aurum_backend/src/http/request_validator.dart';
import 'package:aurum_backend/src/services/aurum_catalog_service.dart';
import 'package:aurum_backend/src/services/aurum_session_service.dart';

class AurumBackendServer {
  AurumBackendServer({
    required BackendRuntimeConfig config,
  }) : _config = config,
       _store = AurumBackendStore(
         dataDirectory: Directory(config.dataDirectoryPath),
       );

  final BackendRuntimeConfig _config;
  final AurumBackendStore _store;

  late final AurumCatalogService _catalogService = AurumCatalogService(
    store: _store,
  );
  late final AurumSessionService _sessionService = AurumSessionService(
    store: _store,
  );

  Future<void> start() async {
    await _store.initialize();
    final HttpServer server = await HttpServer.bind(_config.host, _config.port);
    stdout.writeln(
      'Aurum backend listening on http://${server.address.address}:${_config.port} (${_config.environmentName})',
    );

    await for (final HttpRequest request in server) {
      unawaited(_handle(request));
    }
  }

  Future<void> _handle(HttpRequest request) async {
    final String method = request.method.toUpperCase();
    final String path = request.uri.path;
    final String requestId = DateTime.now().microsecondsSinceEpoch.toString();
    stdout.writeln('[$requestId] $method $path ${request.uri.query}');

    try {
      final String? origin = request.headers.value('origin');
      if (!_config.isOriginAllowed(origin)) {
        throw ApiException(
          statusCode: HttpStatus.forbidden,
          code: 'origin_not_allowed',
          message: 'The request origin is not allowed for this backend.',
        );
      }

      if (method == 'OPTIONS') {
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: const <String, dynamic>{'status': 'ok'},
        );
      }

      if (method == 'GET' && path == '/api/health') {
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: const <String, dynamic>{
            'status': 'ok',
            'service': 'aurum-backend',
          },
          extraMeta: _config.toPublicJson(),
        );
      }

      if (method == 'GET' && path == '/api/session') {
        final String email = RequestValidator.requireEmail(
          request.uri.queryParameters['email'],
          fieldName: 'email query parameter',
        );
        final Map<String, dynamic>? session = _sessionService.restoreSession(email);
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: session,
        );
      }

      if (method == 'POST' && path == '/api/auth/session-sync') {
        final Map<String, dynamic> payload = await _readBody(request);
        final Map<String, dynamic> data = await _sessionService.syncAuthentication(
          payload,
        );
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: data,
        );
      }

      if (method == 'GET' && path == '/api/catalog/restaurants') {
        final List<Map<String, dynamic>> restaurants =
            _catalogService.searchRestaurants(
              search: RequestValidator.queryText(
                request.uri.queryParameters['search'],
                fieldName: 'search',
              ),
              category: RequestValidator.queryText(
                request.uri.queryParameters['category'],
                fieldName: 'category',
                maxLength: 40,
              ),
            );
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: restaurants,
          extraMeta: <String, dynamic>{'count': restaurants.length},
        );
      }

      if (method == 'GET' && path == '/api/catalog/dishes') {
        final List<Map<String, dynamic>> dishes = _catalogService.searchDishes(
          search: RequestValidator.queryText(
            request.uri.queryParameters['search'],
            fieldName: 'search',
          ),
          category: RequestValidator.queryText(
            request.uri.queryParameters['category'],
            fieldName: 'category',
            maxLength: 40,
          ),
        );
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: dishes,
          extraMeta: <String, dynamic>{'count': dishes.length},
        );
      }

      if (method == 'PUT' && path == '/api/user/favorites') {
        final Map<String, dynamic> payload = await _readBody(request);
        final Map<String, dynamic> data = await _sessionService.syncFavorites(
          payload,
        );
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: data,
        );
      }

      if (method == 'PUT' && path == '/api/user/cart') {
        final Map<String, dynamic> payload = await _readBody(request);
        final Map<String, dynamic> data = await _sessionService.syncCart(payload);
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: data,
        );
      }

      if (method == 'PUT' && path == '/api/user/reservations') {
        final Map<String, dynamic> payload = await _readBody(request);
        final Map<String, dynamic> data = await _sessionService.syncReservations(
          payload,
        );
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: data,
        );
      }

      if (method == 'PUT' && path == '/api/user/orders') {
        final Map<String, dynamic> payload = await _readBody(request);
        final Map<String, dynamic> data = await _sessionService.syncOrders(
          payload,
        );
        return _writeSuccess(
          request.response,
          requestId: requestId,
          path: path,
          origin: origin,
          data: data,
        );
      }

      throw ApiException(
        statusCode: HttpStatus.notFound,
        code: 'route_not_found',
        message: 'No route matches $method $path.',
      );
    } on ApiException catch (error) {
      await _writeFailure(
        request.response,
        error,
        requestId: requestId,
        path: path,
        origin: request.headers.value('origin'),
      );
    } on FormatException catch (error) {
      await _writeFailure(
        request.response,
        ApiException(
          statusCode: HttpStatus.badRequest,
          code: 'invalid_json',
          message: error.message,
        ),
        requestId: requestId,
        path: path,
        origin: request.headers.value('origin'),
      );
    } catch (error, stackTrace) {
      stderr.writeln('[$requestId] $error');
      stderr.writeln(stackTrace);
      await _writeFailure(
        request.response,
        ApiException(
          statusCode: HttpStatus.internalServerError,
          code: 'internal_error',
          message: 'The backend could not complete the request.',
        ),
        requestId: requestId,
        path: path,
        origin: request.headers.value('origin'),
      );
    }
  }

  Future<Map<String, dynamic>> _readBody(HttpRequest request) async {
    final String body = await utf8.decoder.bind(request).join();
    if (body.trim().isEmpty) {
      return <String, dynamic>{};
    }
    final Object? decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw const FormatException('Expected a JSON object request body.');
  }

  Future<void> _writeSuccess(
    HttpResponse response, {
    required String requestId,
    required String path,
    required String? origin,
    required Object? data,
    Map<String, dynamic>? extraMeta,
  }) async {
    await _writeJson(
      response,
      HttpStatus.ok,
      ApiResponse.success(
        data: data,
        meta: <String, dynamic>{
          'requestId': requestId,
          'path': path,
          ...?extraMeta,
        },
      ),
      origin,
    );
  }

  Future<void> _writeFailure(
    HttpResponse response,
    ApiException error, {
    required String requestId,
    required String path,
    required String? origin,
  }) async {
    await _writeJson(
      response,
      error.statusCode,
      ApiResponse.failure(
        error,
        meta: <String, dynamic>{'requestId': requestId, 'path': path},
      ),
      origin,
    );
  }

  Future<void> _writeJson(
    HttpResponse response,
    int statusCode,
    Object payload,
    String? origin,
  ) async {
    response.statusCode = statusCode;
    response.headers.contentType = ContentType.json;
    response.headers.set(
      'Access-Control-Allow-Origin',
      _config.resolveAllowedOrigin(origin),
    );
    response.headers.set('Vary', 'Origin');
    response.headers.set(
      'Access-Control-Allow-Headers',
      'Content-Type, Authorization',
    );
    response.headers.set(
      'Access-Control-Allow-Methods',
      'GET, POST, PUT, OPTIONS',
    );
    response.write(jsonEncode(payload));
    await response.close();
  }
}
