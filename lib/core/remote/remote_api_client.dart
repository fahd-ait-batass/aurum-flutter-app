abstract class RemoteApiClient {
  Future<Map<String, dynamic>?> getObject(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>?> postObject(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>?> putObject(
    String path, {
    required Map<String, dynamic> body,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });
}
