import 'package:flutter_app/core/remote/remote_api_client.dart';

class NoopRemoteApiClient implements RemoteApiClient {
  const NoopRemoteApiClient();

  @override
  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return const <Map<String, dynamic>>[];
  }

  @override
  Future<Map<String, dynamic>?> getObject(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> postObject(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> putObject(
    String path, {
    required Map<String, dynamic> body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return null;
  }
}
