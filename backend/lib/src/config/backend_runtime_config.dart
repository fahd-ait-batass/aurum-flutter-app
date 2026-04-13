import 'dart:io';

class BackendRuntimeConfig {
  const BackendRuntimeConfig({
    required this.environmentName,
    required this.host,
    required this.port,
    required this.dataDirectoryPath,
    required this.allowedOrigins,
    this.publicBaseUrl,
  });

  final String environmentName;
  final String host;
  final int port;
  final String dataDirectoryPath;
  final String? publicBaseUrl;
  final Set<String> allowedOrigins;

  factory BackendRuntimeConfig.fromPlatform({List<String> args = const <String>[]}) {
    final Map<String, String> env = Platform.environment;
    final String envPort = env['AURUM_BACKEND_PORT'] ?? '';
    final String platformPort = env['PORT'] ?? '';
    final int port = args.isNotEmpty
        ? int.tryParse(args.first) ?? 8080
        : int.tryParse(envPort) ?? int.tryParse(platformPort) ?? 8080;

    return BackendRuntimeConfig(
      environmentName: (env['AURUM_BACKEND_ENV'] ?? 'development').trim(),
      host: (env['AURUM_BACKEND_HOST'] ?? '0.0.0.0').trim(),
      port: port,
      dataDirectoryPath: _resolveDataDirectoryPath(env),
      publicBaseUrl: _resolvePublicBaseUrl(env),
      allowedOrigins: _parseAllowedOrigins(env['AURUM_ALLOWED_ORIGINS']),
    );
  }

  bool get allowsAnyOrigin => allowedOrigins.contains('*');

  bool isOriginAllowed(String? origin) {
    final String? normalizedOrigin = _optionalValue(origin);
    if (normalizedOrigin == null) {
      return true;
    }
    return allowsAnyOrigin || allowedOrigins.contains(normalizedOrigin);
  }

  String resolveAllowedOrigin(String? origin) {
    final String? normalizedOrigin = _optionalValue(origin);
    if (normalizedOrigin == null || allowsAnyOrigin) {
      return '*';
    }
    return normalizedOrigin;
  }

  Map<String, dynamic> toPublicJson() {
    return <String, dynamic>{
      'environment': environmentName,
      'port': port,
      'publicBaseUrl': publicBaseUrl,
      'allowedOrigins': allowsAnyOrigin
          ? const <String>['*']
          : allowedOrigins.toList(growable: false),
    };
  }

  static Set<String> _parseAllowedOrigins(String? raw) {
    final String normalized = (raw ?? '*').trim();
    if (normalized.isEmpty || normalized == '*') {
      return const <String>{'*'};
    }
    return normalized
        .split(',')
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toSet();
  }

  static String? _optionalValue(String? value) {
    final String normalized = (value ?? '').trim();
    return normalized.isEmpty ? null : normalized;
  }

  static String _resolveDataDirectoryPath(Map<String, String> env) {
    final String? configured = _optionalValue(env['AURUM_BACKEND_DATA_DIR']);
    if (configured != null) {
      return configured;
    }
    final String? railwayVolumePath = _optionalValue(
      env['RAILWAY_VOLUME_MOUNT_PATH'],
    );
    if (railwayVolumePath != null) {
      return railwayVolumePath;
    }
    return 'data';
  }

  static String? _resolvePublicBaseUrl(Map<String, String> env) {
    final String? configured = _optionalValue(env['AURUM_PUBLIC_BASE_URL']);
    if (configured != null) {
      return configured;
    }
    final String? railwayDomain = _optionalValue(env['RAILWAY_PUBLIC_DOMAIN']);
    if (railwayDomain != null) {
      return 'https://$railwayDomain';
    }
    return null;
  }
}
