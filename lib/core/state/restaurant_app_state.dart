import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/data/sample_restaurant_data.dart';
import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/cart_item.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/core/models/remote_catalog_snapshot.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/models/user_profile.dart';
import 'package:flutter_app/core/remote/noop_remote_api_client.dart';
import 'package:flutter_app/core/remote/noop_remote_repositories.dart';
import 'package:flutter_app/core/remote/remote_api_client.dart';
import 'package:flutter_app/core/remote/remote_backend_config.dart';
import 'package:flutter_app/core/remote/remote_sync_status.dart';
import 'package:flutter_app/core/remote/rest_remote_api_client.dart';
import 'package:flutter_app/core/remote/rest_remote_repositories.dart';
import 'package:flutter_app/core/repositories/app_session_repository.dart';
import 'package:flutter_app/core/repositories/catalog_repository.dart';
import 'package:flutter_app/core/repositories/local_app_session_repository.dart';
import 'package:flutter_app/core/repositories/local_catalog_repository.dart';
import 'package:flutter_app/core/services/auth_service.dart';
import 'package:flutter_app/core/services/cart_service.dart';
import 'package:flutter_app/core/services/favorites_service.dart';
import 'package:flutter_app/core/services/order_service.dart';
import 'package:flutter_app/core/services/remote_sync_service.dart';
import 'package:flutter_app/core/services/reservation_service.dart';
import 'package:flutter_app/core/storage/local_app_storage.dart';

class RestaurantAppState extends ChangeNotifier {
  RestaurantAppState._({
    required AppSessionRepository sessionRepository,
    required CatalogRepository catalogRepository,
    required RemoteSyncService remoteSyncService,
    required AuthService authService,
    required FavoritesService favoritesService,
    required CartService cartService,
    required ReservationService reservationService,
    required OrderService orderService,
    required AppSessionState initialSession,
    required RemoteSyncStatus initialRemoteSyncStatus,
    required this.featuredRestaurantId,
    required this.popularDishIds,
    required this.nearbyRestaurantIds,
    required this.discoverRestaurantIds,
  }) : _sessionRepository = sessionRepository,
       _catalogRepository = catalogRepository,
       _remoteSyncService = remoteSyncService,
       _authService = authService,
       _favoritesService = favoritesService,
       _cartService = cartService,
       _reservationService = reservationService,
       _orderService = orderService,
       _defaultSession = initialSession,
       _session = initialSession,
       _remoteSyncStatus = initialRemoteSyncStatus;

  factory RestaurantAppState.seeded({
    LocalAppStorage? storage,
    RemoteBackendConfig? remoteConfig,
    RemoteApiClient? remoteApiClient,
  }) {
    final SampleRestaurantData sample = SampleRestaurantData.build();
    final AppSessionState initialSession = AppSessionState(
      isAuthenticated: true,
      userProfile: sample.userProfile,
      favoriteRestaurantIds: sample.favoriteRestaurantIds,
      favoriteDishIds: sample.favoriteDishIds,
      cartItems: sample.cartItems,
      reservations: sample.reservations,
      orderHistory: sample.orderHistory,
    );
    final AuthService authService = const AuthService();
    final LocalCatalogRepository catalogRepository = LocalCatalogRepository(
      restaurants: sample.restaurants,
      dishes: sample.dishes,
    );
    final RemoteBackendConfig config =
        remoteConfig ?? RemoteBackendConfig.fromEnvironment();
    final RemoteApiClient apiClient =
        remoteApiClient ??
        (config.usesRestClient
            ? RestRemoteApiClient(config: config)
            : const NoopRemoteApiClient());
    final RemoteSyncService remoteSyncService = RemoteSyncService(
      config: config,
      authRepository: config.usesRestClient
          ? RestRemoteAuthRepository(apiClient: apiClient)
          : const NoopRemoteAuthRepository(),
      catalogRepository: config.usesRestClient
          ? RestRemoteCatalogRepository(apiClient: apiClient)
          : const NoopRemoteCatalogRepository(),
      userSyncRepository: config.usesRestClient
          ? RestRemoteUserSyncRepository(apiClient: apiClient)
          : const NoopRemoteUserSyncRepository(),
    );

    return RestaurantAppState._(
      sessionRepository: LocalAppSessionRepository(
        storage: storage ?? LocalAppStorage(),
      ),
      catalogRepository: catalogRepository,
      remoteSyncService: remoteSyncService,
      authService: authService,
      favoritesService: const FavoritesService(),
      cartService: const CartService(),
      reservationService: ReservationService(authService: authService),
      orderService: const OrderService(),
      initialSession: initialSession,
      initialRemoteSyncStatus: remoteSyncService.initialStatus,
      featuredRestaurantId: sample.featuredRestaurantId,
      popularDishIds: sample.popularDishIds,
      nearbyRestaurantIds: sample.nearbyRestaurantIds,
      discoverRestaurantIds: sample.discoverRestaurantIds,
    );
  }

  static const Set<RemoteSyncDomain> _fullSessionSyncDomains =
      <RemoteSyncDomain>{
        RemoteSyncDomain.auth,
        RemoteSyncDomain.favorites,
        RemoteSyncDomain.cart,
        RemoteSyncDomain.reservations,
        RemoteSyncDomain.orders,
      };

  final AppSessionRepository _sessionRepository;
  final CatalogRepository _catalogRepository;
  final RemoteSyncService _remoteSyncService;
  final AuthService _authService;
  final FavoritesService _favoritesService;
  final CartService _cartService;
  final ReservationService _reservationService;
  final OrderService _orderService;
  final AppSessionState _defaultSession;
  AppSessionState _session;

  final String featuredRestaurantId;
  final List<String> popularDishIds;
  final List<String> nearbyRestaurantIds;
  final List<String> discoverRestaurantIds;

  RemoteSyncStatus _remoteSyncStatus;
  Future<void> _remoteSyncQueue = Future<void>.value();
  final Set<RemoteSyncDomain> _pendingRemoteDomains = <RemoteSyncDomain>{};

  bool _isReady = false;
  Object? _bootstrapError;

  bool get isReady => _isReady;
  Object? get bootstrapError => _bootstrapError;
  bool get isAuthenticated => _session.isAuthenticated;
  UserProfile get userProfile => _session.userProfile;
  RemoteSyncStatus get remoteSyncStatus => _remoteSyncStatus;

  List<Restaurant> get restaurants => _catalogRepository.restaurants;
  List<Dish> get dishes => _catalogRepository.dishes;
  List<OrderReceipt> get orderHistory {
    final List<OrderReceipt> sorted = List<OrderReceipt>.from(
      _session.orderHistory,
    );
    sorted.sort(
      (OrderReceipt a, OrderReceipt b) => b.placedAt.compareTo(a.placedAt),
    );
    return List<OrderReceipt>.unmodifiable(sorted);
  }

  List<Reservation> get reservations {
    final List<Reservation> sorted = List<Reservation>.from(_session.reservations);
    sorted.sort((Reservation a, Reservation b) => a.date.compareTo(b.date));
    return List<Reservation>.unmodifiable(sorted);
  }

  List<Reservation> get reservationHistory {
    final List<Reservation> sorted = List<Reservation>.from(_session.reservations);
    sorted.sort(
      (Reservation a, Reservation b) => b.createdAt.compareTo(a.createdAt),
    );
    return List<Reservation>.unmodifiable(sorted);
  }

  Restaurant get featuredRestaurant => restaurantById(featuredRestaurantId);
  List<Dish> get popularDishes =>
      popularDishIds.map(dishById).toList(growable: false);
  List<Restaurant> get nearbyRestaurants =>
      nearbyRestaurantIds.map(restaurantById).toList(growable: false);
  List<Restaurant> get discoverRestaurants =>
      discoverRestaurantIds.map(restaurantById).toList(growable: false);
  List<Restaurant> get favoriteRestaurants => restaurants
      .where((Restaurant item) => _session.favoriteRestaurantIds.contains(item.id))
      .toList(growable: false);
  List<Dish> get favoriteDishes => dishes
      .where((Dish item) => _session.favoriteDishIds.contains(item.id))
      .toList(growable: false);
  List<Dish> get cartDishes => _session.cartItems
      .map((CartItem item) => dishById(item.dishId))
      .toList(growable: false);

  Reservation? get upcomingReservation {
    final DateTime now = DateTime.now();
    for (final Reservation reservation in reservations) {
      if (!reservation.date.isBefore(DateTime(now.year, now.month, now.day))) {
        return reservation;
      }
    }
    return reservations.isEmpty ? null : reservations.first;
  }

  List<Reservation> get pastReservations {
    final DateTime today = DateTime.now();
    return reservationHistory
        .where(
          (Reservation item) =>
              item.date.isBefore(DateTime(today.year, today.month, today.day)),
        )
        .toList(growable: false);
  }

  int get favoriteCount =>
      _session.favoriteRestaurantIds.length + _session.favoriteDishIds.length;
  int get cartCount => _session.cartItems.fold<int>(
    0,
    (int sum, CartItem item) => sum + item.quantity,
  );
  int get reservationCount => _session.reservations.length;
  int get orderCount => _session.orderHistory.length;

  double get subtotalMad => _session.cartItems.fold<double>(0, (
    double sum,
    CartItem item,
  ) {
    return sum + dishById(item.dishId).priceMad * item.quantity;
  });
  double get serviceFeeMad => _session.cartItems.isEmpty ? 0 : subtotalMad * 0.08;
  double get deliveryFeeMad => _session.cartItems.isEmpty ? 0 : 18;
  double get totalMad => subtotalMad + serviceFeeMad + deliveryFeeMad;

  Future<void> hydrate() async {
    _isReady = false;
    _bootstrapError = null;
    notifyListeners();

    try {
      final AppSessionState? session = await _sessionRepository.loadSession();
      _session = session ?? _defaultSession;
    } catch (error) {
      _bootstrapError = error;
      _session = _defaultSession;
    }

    await _bootstrapRemoteState();

    _isReady = true;
    notifyListeners();

    if (_remoteSyncService.isOperational) {
      _enqueueRemoteSync(_fullSessionSyncDomains);
    }
  }

  Future<void> retryHydration() => hydrate();

  Future<void> retryRemoteSync() async {
    if (!_remoteSyncService.isOperational) {
      return;
    }
    await _bootstrapRemoteState();
    _pendingRemoteDomains.addAll(_fullSessionSyncDomains);
    await _flushRemoteSyncQueue();
  }

  Restaurant restaurantById(String restaurantId) {
    return _catalogRepository.findRestaurantById(restaurantId);
  }

  Dish dishById(String dishId) {
    return _catalogRepository.findDishById(dishId);
  }

  List<Dish> dishesForRestaurant(String restaurantId) {
    return _catalogRepository.dishesForRestaurant(restaurantId);
  }

  List<CartLine> get cartLines => _session.cartItems
      .map((CartItem item) => CartLine(dish: dishById(item.dishId), item: item))
      .toList(growable: false);

  List<Restaurant> searchRestaurants(CatalogQuery query) {
    return _catalogRepository.searchRestaurants(query);
  }

  List<Dish> searchDishes(CatalogQuery query) {
    return _catalogRepository.searchDishes(query);
  }

  bool isRestaurantFavorite(String restaurantId) {
    return _session.favoriteRestaurantIds.contains(restaurantId);
  }

  bool isDishFavorite(String dishId) {
    return _session.favoriteDishIds.contains(dishId);
  }

  void toggleRestaurantFavorite(String restaurantId) {
    _session = _favoritesService.toggleRestaurantFavorite(_session, restaurantId);
    _notifyPersistAndSync(const <RemoteSyncDomain>{
      RemoteSyncDomain.favorites,
    });
  }

  void toggleDishFavorite(String dishId) {
    _session = _favoritesService.toggleDishFavorite(_session, dishId);
    _notifyPersistAndSync(const <RemoteSyncDomain>{
      RemoteSyncDomain.favorites,
    });
  }

  void addDishToCart(String dishId, {int quantity = 1}) {
    _session = _cartService.addDish(_session, dishId, quantity: quantity);
    _notifyPersistAndSync(const <RemoteSyncDomain>{RemoteSyncDomain.cart});
  }

  void updateCartItemQuantity(String dishId, int quantity) {
    _session = _cartService.updateDishQuantity(_session, dishId, quantity);
    _notifyPersistAndSync(const <RemoteSyncDomain>{RemoteSyncDomain.cart});
  }

  void clearCart() {
    _session = _cartService.clearCart(_session);
    _notifyPersistAndSync(const <RemoteSyncDomain>{RemoteSyncDomain.cart});
  }

  Reservation createReservation({
    required String restaurantId,
    required DateTime date,
    required String timeLabel,
    required int partySize,
    required String guestName,
    required String guestEmail,
    String? specialRequest,
    String? experienceLabel,
  }) {
    final mutation = _reservationService.createReservation(
      _session,
      restaurant: restaurantById(restaurantId),
      date: date,
      timeLabel: timeLabel,
      partySize: partySize,
      guestName: guestName,
      guestEmail: guestEmail,
      specialRequest: specialRequest,
      experienceLabel: experienceLabel,
    );
    _session = mutation.session;
    _notifyPersistAndSync(const <RemoteSyncDomain>{
      RemoteSyncDomain.reservations,
    });
    return mutation.reservation;
  }

  OrderReceipt? placeOrder({
    String fulfillmentLabel = 'Express delivery',
    String paymentLabel = 'Visa **** 4421',
    String orderNote = '',
  }) {
    final mutation = _orderService.placeOrder(
      _session,
      totalMad: totalMad,
      fulfillmentLabel: fulfillmentLabel,
      paymentLabel: paymentLabel,
      orderNote: orderNote,
    );
    if (mutation == null) {
      return null;
    }
    _session = mutation.session;
    _notifyPersistAndSync(const <RemoteSyncDomain>{
      RemoteSyncDomain.cart,
      RemoteSyncDomain.orders,
    });
    return mutation.receipt;
  }

  void signIn({required String name, required String email}) {
    _session = _authService.signIn(_session, name: name, email: email);
    _notifyPersistAndSync(const <RemoteSyncDomain>{RemoteSyncDomain.auth});
  }

  void signOut() {
    _session = _authService.signOut(_session);
    _notifyPersistAndSync(const <RemoteSyncDomain>{RemoteSyncDomain.auth});
  }

  Future<void> _bootstrapRemoteState() async {
    _remoteSyncStatus = _remoteSyncService.initialStatus;
    if (!_remoteSyncService.isOperational) {
      return;
    }

    _remoteSyncStatus = _remoteSyncStatus.copyWith(
      stage: RemoteSyncStage.syncing,
      message: 'Refreshing your secure session and the live dining catalog.',
      pendingDomains: const <RemoteSyncDomain>{
        RemoteSyncDomain.auth,
        RemoteSyncDomain.catalog,
      },
      lastAttemptedAt: DateTime.now(),
      clearError: true,
    );
    notifyListeners();

    try {
      final List<dynamic> results = await Future.wait<dynamic>(<Future<dynamic>>[
        _remoteSyncService.restoreSession(localSession: _session),
        _remoteSyncService.refreshCatalog(),
      ]);
      final AppSessionState? remoteSession = results[0] as AppSessionState?;
      final RemoteCatalogSnapshot? remoteCatalog =
          results[1] as RemoteCatalogSnapshot?;

      if (remoteSession != null) {
        _session = remoteSession;
      }
      if (remoteCatalog != null && remoteCatalog.hasEntries) {
        _catalogRepository.replaceCatalog(
          restaurants: remoteCatalog.restaurants,
          dishes: remoteCatalog.dishes,
        );
      }

      _remoteSyncStatus = _remoteSyncStatus.copyWith(
        stage: RemoteSyncStage.success,
        message: 'Remote session and catalog are ready.',
        pendingDomains: const <RemoteSyncDomain>{},
        lastSuccessfulSyncAt: DateTime.now(),
        clearError: true,
      );
    } catch (error) {
      _remoteSyncStatus = _remoteSyncStatus.copyWith(
        stage: RemoteSyncStage.error,
        message:
            'Local data is ready. Remote sync will retry when the backend is reachable.',
        pendingDomains: const <RemoteSyncDomain>{},
        error: error,
      );
    }
  }

  void _notifyPersistAndSync(Set<RemoteSyncDomain> domains) {
    notifyListeners();
    if (_isReady) {
      unawaited(_sessionRepository.saveSession(_session));
      _enqueueRemoteSync(domains);
    }
  }

  void _enqueueRemoteSync(Set<RemoteSyncDomain> domains) {
    if (!_remoteSyncService.isOperational || domains.isEmpty) {
      return;
    }
    _pendingRemoteDomains.addAll(domains);
    _remoteSyncQueue = _remoteSyncQueue.then((_) => _flushRemoteSyncQueue());
    unawaited(_remoteSyncQueue);
  }

  Future<void> _flushRemoteSyncQueue() async {
    if (_pendingRemoteDomains.isEmpty) {
      return;
    }

    final Set<RemoteSyncDomain> domainsToSync = Set<RemoteSyncDomain>.from(
      _pendingRemoteDomains,
    );
    _remoteSyncStatus = _remoteSyncStatus.copyWith(
      stage: RemoteSyncStage.syncing,
      message: _buildSyncMessage(domainsToSync),
      pendingDomains: domainsToSync,
      lastAttemptedAt: DateTime.now(),
      clearError: true,
    );
    notifyListeners();

    try {
      await _remoteSyncService.syncSession(
        _session,
        domains: domainsToSync,
      );
      _pendingRemoteDomains.removeAll(domainsToSync);
      _remoteSyncStatus = _remoteSyncStatus.copyWith(
        stage: RemoteSyncStage.success,
        message: 'Saved locally and synced with the remote account.',
        pendingDomains: Set<RemoteSyncDomain>.from(_pendingRemoteDomains),
        lastSuccessfulSyncAt: DateTime.now(),
        clearError: true,
      );
    } catch (error) {
      _remoteSyncStatus = _remoteSyncStatus.copyWith(
        stage: RemoteSyncStage.error,
        message:
            'Saved locally. Remote sync is pending until the backend is reachable.',
        pendingDomains: Set<RemoteSyncDomain>.from(_pendingRemoteDomains),
        error: error,
      );
    }
    notifyListeners();
  }

  String _buildSyncMessage(Set<RemoteSyncDomain> domains) {
    final List<String> labels = domains
        .map<String>(_domainLabel)
        .toList(growable: false)
      ..sort();
    return 'Syncing ${labels.join(', ')} with your remote account.';
  }

  String _domainLabel(RemoteSyncDomain domain) {
    switch (domain) {
      case RemoteSyncDomain.auth:
        return 'account';
      case RemoteSyncDomain.catalog:
        return 'catalog';
      case RemoteSyncDomain.favorites:
        return 'favorites';
      case RemoteSyncDomain.cart:
        return 'cart';
      case RemoteSyncDomain.reservations:
        return 'reservations';
      case RemoteSyncDomain.orders:
        return 'orders';
    }
  }
}

class CartLine {
  const CartLine({required this.dish, required this.item});

  final Dish dish;
  final CartItem item;
}
