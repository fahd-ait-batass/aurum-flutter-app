enum RemoteBackendProvider { disabled, rest, firebase, supabase }
enum RemoteBackendTarget { disabled, local, hosted, custom }

class RemoteBackendConfig {
  const RemoteBackendConfig({
    required this.provider,
    this.target = RemoteBackendTarget.local,
    this.baseUrl,
    this.authToken,
    this.environmentName = 'development',
    this.connectTimeout = const Duration(seconds: 8),
    this.readTimeout = const Duration(seconds: 12),
  });

  final RemoteBackendProvider provider;
  final RemoteBackendTarget target;
  final String? baseUrl;
  final String? authToken;
  final String environmentName;
  final Duration connectTimeout;
  final Duration readTimeout;

  factory RemoteBackendConfig.fromEnvironment() {
    const String targetValue = String.fromEnvironment(
      'AURUM_BACKEND_TARGET',
      defaultValue: 'local',
    );
    const String providerValue = String.fromEnvironment(
      'AURUM_REMOTE_PROVIDER',
      defaultValue: 'rest',
    );
    const String baseUrl = String.fromEnvironment(
      'AURUM_REMOTE_BASE_URL',
      defaultValue: 'https://aurum-flutter-app-production.up.railway.app/api',
    );
    const String localBaseUrl = String.fromEnvironment(
      'AURUM_LOCAL_BACKEND_URL',
      defaultValue: 'http://10.0.2.2:8080/api',
    );
    const String authToken = String.fromEnvironment(
      'AURUM_REMOTE_AUTH_TOKEN',
      defaultValue: '',
    );
    const String environmentName = String.fromEnvironment(
      'AURUM_APP_ENV',
      defaultValue: 'development',
    );
    final RemoteBackendTarget target = _parseTarget(targetValue);

    return RemoteBackendConfig(
      provider: target == RemoteBackendTarget.disabled
          ? RemoteBackendProvider.disabled
          : _parseProvider(providerValue),
      target: target,
      baseUrl: _resolveBaseUrl(target, localBaseUrl: localBaseUrl, remoteBaseUrl: baseUrl),
      authToken: authToken.isEmpty ? null : authToken,
      environmentName: environmentName,
    );
  }

  Uri? get baseUri {
    final String normalized = (baseUrl ?? '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return Uri.tryParse(normalized);
  }

  bool get isEnabled => provider != RemoteBackendProvider.disabled;
  bool get usesRestClient =>
      provider == RemoteBackendProvider.rest && baseUri != null;
  bool get isHostedTarget => target == RemoteBackendTarget.hosted;
  bool get isLocalTarget => target == RemoteBackendTarget.local;

  String get backendLabel => switch (provider) {
    RemoteBackendProvider.disabled => 'Local-only mode',
    RemoteBackendProvider.rest => 'REST backend',
    RemoteBackendProvider.firebase => 'Firebase backend',
    RemoteBackendProvider.supabase => 'Supabase backend',
  };

  String get statusMessage {
    if (!isEnabled) {
      return 'Remote sync is disabled for this build.';
    }
    if (usesRestClient) {
      final String targetLabel = switch (target) {
        RemoteBackendTarget.disabled => 'disabled',
        RemoteBackendTarget.local => 'local',
        RemoteBackendTarget.hosted => 'hosted',
        RemoteBackendTarget.custom => 'custom',
      };
      return 'Remote sync is configured for ${baseUri!.host} ($targetLabel).';
    }
    if (provider == RemoteBackendProvider.rest) {
      return 'REST sync is enabled, but the backend base URL is missing.';
    }
    return '$backendLabel support is scaffolded and ready for implementation.';
  }

  static RemoteBackendProvider _parseProvider(String value) {
    switch (value.trim().toLowerCase()) {
      case 'rest':
      case 'api':
        return RemoteBackendProvider.rest;
      case 'firebase':
        return RemoteBackendProvider.firebase;
      case 'supabase':
        return RemoteBackendProvider.supabase;
      default:
        return RemoteBackendProvider.disabled;
    }
  }

  static RemoteBackendTarget _parseTarget(String value) {
    switch (value.trim().toLowerCase()) {
      case 'disabled':
      case 'off':
        return RemoteBackendTarget.disabled;
      case 'hosted':
      case 'production':
      case 'remote':
        return RemoteBackendTarget.hosted;
      case 'custom':
        return RemoteBackendTarget.custom;
      case 'local':
      default:
        return RemoteBackendTarget.local;
    }
  }

  static String? _resolveBaseUrl(
    RemoteBackendTarget target, {
    required String localBaseUrl,
    required String remoteBaseUrl,
  }) {
    switch (target) {
      case RemoteBackendTarget.disabled:
        return null;
      case RemoteBackendTarget.local:
        return localBaseUrl.trim().isEmpty ? null : localBaseUrl.trim();
      case RemoteBackendTarget.hosted:
      case RemoteBackendTarget.custom:
        return remoteBaseUrl.trim().isEmpty ? null : remoteBaseUrl.trim();
    }
  }
}
