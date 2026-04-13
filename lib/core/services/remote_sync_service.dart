import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/remote_catalog_snapshot.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/remote/remote_backend_config.dart';
import 'package:flutter_app/core/remote/remote_sync_status.dart';
import 'package:flutter_app/core/repositories/remote_auth_repository.dart';
import 'package:flutter_app/core/repositories/remote_catalog_repository.dart';
import 'package:flutter_app/core/repositories/remote_user_sync_repository.dart';

class RemoteSyncService {
  const RemoteSyncService({
    required RemoteBackendConfig config,
    required RemoteAuthRepository authRepository,
    required RemoteCatalogRepository catalogRepository,
    required RemoteUserSyncRepository userSyncRepository,
  }) : _config = config,
       _authRepository = authRepository,
       _catalogRepository = catalogRepository,
       _userSyncRepository = userSyncRepository;

  final RemoteBackendConfig _config;
  final RemoteAuthRepository _authRepository;
  final RemoteCatalogRepository _catalogRepository;
  final RemoteUserSyncRepository _userSyncRepository;

  RemoteSyncStatus get initialStatus {
    if (!_config.isEnabled) {
      return RemoteSyncStatus.disabled(message: _config.statusMessage);
    }
    if (!_config.usesRestClient) {
      return RemoteSyncStatus(
        stage: RemoteSyncStage.error,
        message: _config.statusMessage,
      );
    }
    return RemoteSyncStatus.idle(message: _config.statusMessage);
  }

  bool get isOperational => _config.usesRestClient;

  Future<AppSessionState?> restoreSession({
    required AppSessionState localSession,
  }) {
    if (!isOperational) {
      return Future<AppSessionState?>.value(null);
    }
    return _authRepository.restoreSession(localSession: localSession);
  }

  Future<RemoteCatalogSnapshot?> refreshCatalog({CatalogQuery? query}) async {
    if (!isOperational) {
      return null;
    }

    final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
      _catalogRepository.fetchRestaurants(query: query),
      _catalogRepository.fetchDishes(query: query),
    ]);

    final List<Restaurant>? restaurants = results[0] as List<Restaurant>?;
    final List<Dish>? dishes = results[1] as List<Dish>?;
    if (restaurants == null || dishes == null) {
      return null;
    }
    return RemoteCatalogSnapshot(restaurants: restaurants, dishes: dishes);
  }

  Future<void> syncSession(
    AppSessionState session, {
    required Set<RemoteSyncDomain> domains,
  }) async {
    if (!isOperational || domains.isEmpty) {
      return;
    }

    if (domains.contains(RemoteSyncDomain.auth)) {
      await _authRepository.syncAuthentication(session);
    }
    if (domains.contains(RemoteSyncDomain.favorites)) {
      await _userSyncRepository.syncFavorites(session);
    }
    if (domains.contains(RemoteSyncDomain.cart)) {
      await _userSyncRepository.syncCart(session);
    }
    if (domains.contains(RemoteSyncDomain.reservations)) {
      await _userSyncRepository.syncReservations(session);
    }
    if (domains.contains(RemoteSyncDomain.orders)) {
      await _userSyncRepository.syncOrders(session);
    }
  }
}
