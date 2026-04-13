enum RemoteSyncStage { disabled, idle, syncing, success, error }

enum RemoteSyncDomain {
  auth,
  catalog,
  favorites,
  cart,
  reservations,
  orders,
}

class RemoteSyncStatus {
  const RemoteSyncStatus({
    required this.stage,
    required this.message,
    this.pendingDomains = const <RemoteSyncDomain>{},
    this.lastAttemptedAt,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final RemoteSyncStage stage;
  final String message;
  final Set<RemoteSyncDomain> pendingDomains;
  final DateTime? lastAttemptedAt;
  final DateTime? lastSuccessfulSyncAt;
  final Object? error;

  bool get isEnabled => stage != RemoteSyncStage.disabled;
  bool get isSyncing => stage == RemoteSyncStage.syncing;
  bool get hasError => stage == RemoteSyncStage.error;
  bool get isHealthy => stage == RemoteSyncStage.success;
  bool get hasPendingDomains => pendingDomains.isNotEmpty;

  factory RemoteSyncStatus.disabled({
    String message = 'Remote sync is disabled for this build.',
  }) {
    return RemoteSyncStatus(
      stage: RemoteSyncStage.disabled,
      message: message,
    );
  }

  factory RemoteSyncStatus.idle({
    String message = 'Remote sync is ready.',
  }) {
    return RemoteSyncStatus(stage: RemoteSyncStage.idle, message: message);
  }

  RemoteSyncStatus copyWith({
    RemoteSyncStage? stage,
    String? message,
    Set<RemoteSyncDomain>? pendingDomains,
    DateTime? lastAttemptedAt,
    DateTime? lastSuccessfulSyncAt,
    Object? error,
    bool clearError = false,
  }) {
    return RemoteSyncStatus(
      stage: stage ?? this.stage,
      message: message ?? this.message,
      pendingDomains:
          pendingDomains ?? Set<RemoteSyncDomain>.from(this.pendingDomains),
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      lastSuccessfulSyncAt:
          lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
