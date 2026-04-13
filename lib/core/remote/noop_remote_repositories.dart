import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/repositories/remote_auth_repository.dart';
import 'package:flutter_app/core/repositories/remote_catalog_repository.dart';
import 'package:flutter_app/core/repositories/remote_user_sync_repository.dart';

class NoopRemoteAuthRepository implements RemoteAuthRepository {
  const NoopRemoteAuthRepository();

  @override
  Future<AppSessionState?> restoreSession({
    required AppSessionState localSession,
  }) async {
    return null;
  }

  @override
  Future<void> syncAuthentication(AppSessionState session) async {}
}

class NoopRemoteCatalogRepository implements RemoteCatalogRepository {
  const NoopRemoteCatalogRepository();

  @override
  Future<List<Dish>?> fetchDishes({CatalogQuery? query}) async {
    return null;
  }

  @override
  Future<List<Restaurant>?> fetchRestaurants({CatalogQuery? query}) async {
    return null;
  }
}

class NoopRemoteUserSyncRepository implements RemoteUserSyncRepository {
  const NoopRemoteUserSyncRepository();

  @override
  Future<void> syncCart(AppSessionState session) async {}

  @override
  Future<void> syncFavorites(AppSessionState session) async {}

  @override
  Future<void> syncOrders(AppSessionState session) async {}

  @override
  Future<void> syncReservations(AppSessionState session) async {}
}
