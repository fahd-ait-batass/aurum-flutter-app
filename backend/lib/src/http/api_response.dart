import 'package:aurum_backend/src/http/api_exception.dart';

class ApiResponse {
  const ApiResponse._();

  static Map<String, dynamic> success({
    Object? data,
    Map<String, dynamic>? meta,
  }) {
    return <String, dynamic>{
      'ok': true,
      'data': data,
      'meta': _meta(meta),
    };
  }

  static Map<String, dynamic> failure(
    ApiException error, {
    Map<String, dynamic>? meta,
  }) {
    return <String, dynamic>{
      'ok': false,
      'error': error.toJson(),
      'meta': _meta(meta),
    };
  }

  static Map<String, dynamic> _meta(Map<String, dynamic>? meta) {
    return <String, dynamic>{
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      ...?meta,
    };
  }
}
