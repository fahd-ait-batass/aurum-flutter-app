import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/remote/remote_api_client.dart';
import 'package:flutter_app/core/repositories/remote_auth_repository.dart';
import 'package:flutter_app/core/repositories/remote_catalog_repository.dart';
import 'package:flutter_app/core/repositories/remote_user_sync_repository.dart';

class RestRemoteAuthRepository implements RemoteAuthRepository {
  const RestRemoteAuthRepository({required RemoteApiClient apiClient})
    : _apiClient = apiClient;

  final RemoteApiClient _apiClient;

  @override
  Future<AppSessionState?> restoreSession({
    required AppSessionState localSession,
  }) async {
    final String email = localSession.userProfile.email.trim();
    final Map<String, String> queryParameters = <String, String>{
      if (email.isNotEmpty) 'email': email,
    };
    final Map<String, dynamic>? json = await _apiClient.getObject(
      '/session',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    if (json == null || json.isEmpty) {
      return null;
    }
    final Object? sessionPayload = json['session'];
    if (sessionPayload is Map<String, dynamic>) {
      return AppSessionState.fromJson(sessionPayload);
    }
    return AppSessionState.fromJson(json);
  }

  @override
  Future<void> syncAuthentication(AppSessionState session) async {
    await _apiClient.postObject(
      '/auth/session-sync',
      body: <String, dynamic>{
        'isAuthenticated': session.isAuthenticated,
        'userProfile': session.userProfile.toJson(),
      },
    );
  }
}

class RestRemoteCatalogRepository implements RemoteCatalogRepository {
  const RestRemoteCatalogRepository({required RemoteApiClient apiClient})
    : _apiClient = apiClient;

  final RemoteApiClient _apiClient;

  @override
  Future<List<Dish>?> fetchDishes({CatalogQuery? query}) async {
    final List<Map<String, dynamic>> json = await _apiClient.getCollection(
      '/catalog/dishes',
      queryParameters: _buildQueryParameters(query),
    );
    return json
        .map((Map<String, dynamic> item) => Dish.fromJson(item))
        .toList(growable: false);
  }

  @override
  Future<List<Restaurant>?> fetchRestaurants({CatalogQuery? query}) async {
    final List<Map<String, dynamic>> json = await _apiClient.getCollection(
      '/catalog/restaurants',
      queryParameters: _buildQueryParameters(query),
    );
    return json
        .map((Map<String, dynamic> item) => Restaurant.fromJson(item))
        .toList(growable: false);
  }

  Map<String, String>? _buildQueryParameters(CatalogQuery? query) {
    if (query == null) {
      return null;
    }
    final Map<String, String> queryParameters = <String, String>{
      if (query.hasSearchText) 'search': query.searchText.trim(),
      if (query.hasCategory) 'category': query.category!.trim(),
    };
    return queryParameters.isEmpty ? null : queryParameters;
  }
}

class RestRemoteUserSyncRepository implements RemoteUserSyncRepository {
  const RestRemoteUserSyncRepository({required RemoteApiClient apiClient})
    : _apiClient = apiClient;

  final RemoteApiClient _apiClient;

  @override
  Future<void> syncCart(AppSessionState session) async {
    await _apiClient.putObject(
      '/user/cart',
      body: <String, dynamic>{
        ..._userEnvelope(session),
        'items': session.cartItems.map((item) => item.toJson()).toList(),
      },
    );
  }

  @override
  Future<void> syncFavorites(AppSessionState session) async {
    await _apiClient.putObject(
      '/user/favorites',
      body: <String, dynamic>{
        ..._userEnvelope(session),
        'restaurantIds': session.favoriteRestaurantIds.toList()..sort(),
        'dishIds': session.favoriteDishIds.toList()..sort(),
      },
    );
  }

  @override
  Future<void> syncOrders(AppSessionState session) async {
    await _apiClient.putObject(
      '/user/orders',
      body: <String, dynamic>{
        ..._userEnvelope(session),
        'orders': session.orderHistory
            .map((OrderReceipt order) => order.toJson())
            .toList(growable: false),
      },
    );
  }

  @override
  Future<void> syncReservations(AppSessionState session) async {
    await _apiClient.putObject(
      '/user/reservations',
      body: <String, dynamic>{
        ..._userEnvelope(session),
        'reservations': session.reservations
            .map((Reservation reservation) => reservation.toJson())
            .toList(growable: false),
      },
    );
  }

  Map<String, dynamic> _userEnvelope(AppSessionState session) {
    return <String, dynamic>{
      'userEmail': session.userProfile.email,
      'userProfile': session.userProfile.toJson(),
    };
  }
}
