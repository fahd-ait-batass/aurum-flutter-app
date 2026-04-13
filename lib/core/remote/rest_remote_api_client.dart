import 'dart:convert';

import 'package:flutter_app/core/remote/remote_api_client.dart';
import 'package:flutter_app/core/remote/remote_backend_config.dart';
import 'package:http/http.dart' as http;

class RestRemoteApiClient implements RemoteApiClient {
  RestRemoteApiClient({
    required RemoteBackendConfig config,
    http.Client? client,
  }) : _config = config,
       _client = client ?? http.Client();

  final RemoteBackendConfig _config;
  final http.Client _client;

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final dynamic payload = await _send(
      () => _client.get(
        _buildUri(path, queryParameters: queryParameters),
        headers: _baseHeaders(headers),
      ),
    );
    if (payload == null) {
      return const <Map<String, dynamic>>[];
    }
    if (payload is List<dynamic>) {
      return payload
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);
    }
    throw RemoteApiException(
      message:
          'Expected a JSON array from $path, but received ${payload.runtimeType}.',
    );
  }

  @override
  Future<Map<String, dynamic>?> getObject(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final dynamic payload = await _send(
      () => _client.get(
        _buildUri(path, queryParameters: queryParameters),
        headers: _baseHeaders(headers),
      ),
    );
    return _castObject(payload, path);
  }

  @override
  Future<Map<String, dynamic>?> postObject(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final dynamic payload = await _send(
      () => _client.post(
        _buildUri(path, queryParameters: queryParameters),
        headers: _jsonHeaders(headers),
        body: jsonEncode(body ?? const <String, dynamic>{}),
      ),
    );
    return _castObject(payload, path);
  }

  @override
  Future<Map<String, dynamic>?> putObject(
    String path, {
    required Map<String, dynamic> body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final dynamic payload = await _send(
      () => _client.put(
        _buildUri(path, queryParameters: queryParameters),
        headers: _jsonHeaders(headers),
        body: jsonEncode(body),
      ),
    );
    return _castObject(payload, path);
  }

  Uri _buildUri(
    String path, {
    Map<String, String>? queryParameters,
  }) {
    final Uri? baseUri = _config.baseUri;
    if (baseUri == null) {
      throw const RemoteApiException(
        message:
            'Remote base URL is missing. Add AURUM_REMOTE_BASE_URL to enable REST sync.',
      );
    }

    final String basePath = baseUri.path.endsWith('/')
        ? baseUri.path.substring(0, baseUri.path.length - 1)
        : baseUri.path;
    final String relativePath = path.startsWith('/') ? path : '/$path';

    return baseUri.replace(
      path: '$basePath$relativePath',
      queryParameters: queryParameters == null || queryParameters.isEmpty
          ? null
          : queryParameters,
    );
  }

  Map<String, String> _baseHeaders(Map<String, String>? headers) {
    return <String, String>{
      'Accept': 'application/json',
      if (_config.authToken != null && _config.authToken!.trim().isNotEmpty)
        'Authorization': 'Bearer ${_config.authToken!.trim()}',
      ...?headers,
    };
  }

  Map<String, String> _jsonHeaders(Map<String, String>? headers) {
    return <String, String>{
      'Content-Type': 'application/json',
      ..._baseHeaders(headers),
    };
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    final http.Response response = await request().timeout(_config.readTimeout);

    if (response.body.isEmpty) {
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw RemoteApiException(
          message: 'Remote request failed with status ${response.statusCode}.',
          statusCode: response.statusCode,
        );
      }
      return null;
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded.containsKey('ok')) {
      final bool ok = decoded['ok'] == true;
      if (!ok) {
        final Map<String, dynamic> error =
            decoded['error'] as Map<String, dynamic>? ?? <String, dynamic>{};
        throw RemoteApiException(
          message:
              error['message'] as String? ??
              'Remote request failed with status ${response.statusCode}.',
          code: error['code'] as String?,
          statusCode: response.statusCode,
          details: error['details'],
        );
      }
      return decoded['data'];
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RemoteApiException(
        message:
            'Remote request failed with status ${response.statusCode}: ${response.body}',
        statusCode: response.statusCode,
      );
    }

    return decoded;
  }

  Map<String, dynamic>? _castObject(dynamic payload, String path) {
    if (payload == null) {
      return null;
    }
    if (payload is Map<String, dynamic>) {
      return payload;
    }
    throw RemoteApiException(
      message:
          'Expected a JSON object from $path, but received ${payload.runtimeType}.',
    );
  }
}

class RemoteApiException implements Exception {
  const RemoteApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
  });

  final String message;
  final String? code;
  final int? statusCode;
  final Object? details;

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer('RemoteApiException');
    if (statusCode != null) {
      buffer.write('($statusCode');
      if (code != null) {
        buffer.write('/$code');
      }
      buffer.write(')');
    } else if (code != null) {
      buffer.write('($code)');
    }
    buffer.write(': $message');
    return buffer.toString();
  }
}
