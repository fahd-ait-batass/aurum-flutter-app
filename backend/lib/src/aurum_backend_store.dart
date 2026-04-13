import 'dart:io';

import 'package:aurum_backend/src/storage/atomic_json_file_store.dart';

class AurumBackendStore {
  AurumBackendStore({
    required Directory dataDirectory,
  }) : _catalogStore = AtomicJsonFileStore(
         file: File('${dataDirectory.path}\\catalog.json'),
         defaultValue: const <String, dynamic>{
           'restaurants': <dynamic>[],
           'dishes': <dynamic>[],
         },
       ),
       _sessionsStore = AtomicJsonFileStore(
         file: File('${dataDirectory.path}\\user_sessions.json'),
         defaultValue: const <String, dynamic>{},
       );

  final AtomicJsonFileStore _catalogStore;
  final AtomicJsonFileStore _sessionsStore;

  Map<String, dynamic> _catalog = const <String, dynamic>{
    'restaurants': <dynamic>[],
    'dishes': <dynamic>[],
  };
  Map<String, dynamic> _sessions = const <String, dynamic>{};

  Future<void> initialize() async {
    _catalog = await _catalogStore.load();
    _sessions = await _sessionsStore.load();
  }

  List<Map<String, dynamic>> get restaurants =>
      readObjectList(_catalog['restaurants']);

  List<Map<String, dynamic>> get dishes => readObjectList(_catalog['dishes']);

  Map<String, dynamic>? getSessionByEmail(String email) {
    final Object? session = _sessions[email];
    if (session is Map<String, dynamic>) {
      return cloneMap(session);
    }
    return null;
  }

  Future<void> upsertAuthentication({
    required String email,
    required Map<String, dynamic> userProfile,
    required bool isAuthenticated,
  }) async {
    final Map<String, dynamic> session = _ensureSession(
      email: email,
      userProfile: userProfile,
    );
    session['isAuthenticated'] = isAuthenticated;
    session['userProfile'] = cloneMap(userProfile);
    await _persistSessions();
  }

  Future<void> updateFavorites({
    required String email,
    required Map<String, dynamic> userProfile,
    required List<String> restaurantIds,
    required List<String> dishIds,
  }) async {
    final Map<String, dynamic> session = _ensureSession(
      email: email,
      userProfile: userProfile,
    );
    session['favoriteRestaurantIds'] = List<String>.from(restaurantIds);
    session['favoriteDishIds'] = List<String>.from(dishIds);
    await _persistSessions();
  }

  Future<void> updateCart({
    required String email,
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> items,
  }) async {
    final Map<String, dynamic> session = _ensureSession(
      email: email,
      userProfile: userProfile,
    );
    session['cartItems'] = items.map(cloneMap).toList(growable: false);
    await _persistSessions();
  }

  Future<void> updateReservations({
    required String email,
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> reservations,
  }) async {
    final Map<String, dynamic> session = _ensureSession(
      email: email,
      userProfile: userProfile,
    );
    session['reservations'] = reservations.map(cloneMap).toList(growable: false);
    await _persistSessions();
  }

  Future<void> updateOrders({
    required String email,
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> orders,
  }) async {
    final Map<String, dynamic> session = _ensureSession(
      email: email,
      userProfile: userProfile,
    );
    session['orderHistory'] = orders.map(cloneMap).toList(growable: false);
    await _persistSessions();
  }

  Map<String, dynamic> _ensureSession({
    required String email,
    required Map<String, dynamic> userProfile,
  }) {
    final Map<String, dynamic> current = cloneMap(
      (_sessions[email] as Map<String, dynamic>?) ?? <String, dynamic>{},
    );
    final Map<String, dynamic> session = <String, dynamic>{
      'isAuthenticated': current['isAuthenticated'] as bool? ?? true,
      'userProfile': cloneMap(
        (current['userProfile'] as Map<String, dynamic>?) ?? userProfile,
      ),
      'favoriteRestaurantIds': readStringList(current['favoriteRestaurantIds']),
      'favoriteDishIds': readStringList(current['favoriteDishIds']),
      'cartItems': readObjectList(current['cartItems']),
      'reservations': readObjectList(current['reservations']),
      'orderHistory': readObjectList(current['orderHistory']),
    };
    if (userProfile.isNotEmpty) {
      session['userProfile'] = cloneMap(userProfile);
    }
    _sessions[email] = session;
    return session;
  }

  Future<void> _persistSessions() async {
    await _sessionsStore.write(_sessions);
  }

  List<Map<String, dynamic>> readObjectList(Object? value) {
    final List<dynamic> items = value as List<dynamic>? ?? <dynamic>[];
    return items
        .map(
          (dynamic item) => cloneMap(
            item as Map<String, dynamic>? ?? <String, dynamic>{},
          ),
        )
        .toList(growable: false);
  }

  List<String> readStringList(Object? value) {
    final List<dynamic> items = value as List<dynamic>? ?? <dynamic>[];
    return items.map((dynamic item) => item as String).toList(growable: false);
  }

  Map<String, dynamic> cloneMap(Map<String, dynamic> source) {
    return Map<String, dynamic>.from(source);
  }
}
