import 'dart:io';

import 'package:aurum_backend/src/http/api_exception.dart';

class RequestValidator {
  const RequestValidator._();

  static final RegExp _emailPattern = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    caseSensitive: false,
  );

  static String requireEmail(
    String? value, {
    String fieldName = 'email',
  }) {
    final String normalized = (value ?? '').trim().toLowerCase();
    if (normalized.isEmpty || !_emailPattern.hasMatch(normalized)) {
      throw ApiException(
        statusCode: HttpStatus.badRequest,
        code: 'invalid_email',
        message: 'A valid $fieldName is required.',
      );
    }
    return normalized;
  }

  static bool requireBool(
    Map<String, dynamic> payload,
    String fieldName, {
    bool fallback = true,
  }) {
    final Object? value = payload[fieldName];
    if (value == null) {
      return fallback;
    }
    if (value is bool) {
      return value;
    }
    throw ApiException(
      statusCode: HttpStatus.badRequest,
      code: 'invalid_boolean',
      message: '"$fieldName" must be a boolean.',
    );
  }

  static Map<String, dynamic> requireMap(
    Map<String, dynamic> payload,
    String fieldName,
  ) {
    final Object? value = payload[fieldName];
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    throw ApiException(
      statusCode: HttpStatus.badRequest,
      code: 'invalid_payload',
      message: '"$fieldName" must be a JSON object.',
    );
  }

  static String optionalString(
    Map<String, dynamic> payload,
    String fieldName, {
    int maxLength = 120,
  }) {
    final Object? value = payload[fieldName];
    if (value == null) {
      return '';
    }
    if (value is! String) {
      throw ApiException(
        statusCode: HttpStatus.badRequest,
        code: 'invalid_string',
        message: '"$fieldName" must be a string.',
      );
    }
    final String normalized = value.trim();
    if (normalized.length > maxLength) {
      throw ApiException(
        statusCode: HttpStatus.badRequest,
        code: 'string_too_long',
        message: '"$fieldName" exceeds the maximum length of $maxLength.',
      );
    }
    return normalized;
  }

  static List<String> stringList(
    Map<String, dynamic> payload,
    String fieldName, {
    int itemMaxLength = 120,
  }) {
    final Object? value = payload[fieldName];
    if (value == null) {
      return const <String>[];
    }
    if (value is! List<dynamic>) {
      throw ApiException(
        statusCode: HttpStatus.badRequest,
        code: 'invalid_list',
        message: '"$fieldName" must be a JSON array.',
      );
    }
    return value.map((dynamic item) {
      if (item is! String) {
        throw ApiException(
          statusCode: HttpStatus.badRequest,
          code: 'invalid_list_item',
          message: '"$fieldName" must contain only strings.',
        );
      }
      final String normalized = item.trim();
      if (normalized.isEmpty || normalized.length > itemMaxLength) {
        throw ApiException(
          statusCode: HttpStatus.badRequest,
          code: 'invalid_list_item',
          message:
              '"$fieldName" contains an empty or overlong string item.',
        );
      }
      return normalized;
    }).toList(growable: false);
  }

  static List<Map<String, dynamic>> objectList(
    Map<String, dynamic> payload,
    String fieldName,
  ) {
    final Object? value = payload[fieldName];
    if (value == null) {
      return const <Map<String, dynamic>>[];
    }
    if (value is! List<dynamic>) {
      throw ApiException(
        statusCode: HttpStatus.badRequest,
        code: 'invalid_list',
        message: '"$fieldName" must be a JSON array.',
      );
    }
    return value.map((dynamic item) {
      if (item is! Map<String, dynamic>) {
        throw ApiException(
          statusCode: HttpStatus.badRequest,
          code: 'invalid_list_item',
          message: '"$fieldName" must contain only objects.',
        );
      }
      return Map<String, dynamic>.from(item);
    }).toList(growable: false);
  }

  static String queryText(
    String? value, {
    String fieldName = 'query',
    int maxLength = 80,
  }) {
    final String normalized = (value ?? '').trim();
    if (normalized.length > maxLength) {
      throw ApiException(
        statusCode: HttpStatus.badRequest,
        code: 'query_too_long',
        message: '"$fieldName" exceeds the maximum length of $maxLength.',
      );
    }
    return normalized;
  }
}
