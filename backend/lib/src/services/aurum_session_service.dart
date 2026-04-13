import 'package:aurum_backend/src/aurum_backend_store.dart';
import 'package:aurum_backend/src/http/request_validator.dart';

class AurumSessionService {
  const AurumSessionService({required AurumBackendStore store}) : _store = store;

  final AurumBackendStore _store;

  Map<String, dynamic>? restoreSession(String email) {
    final String normalizedEmail = RequestValidator.requireEmail(email);
    final Map<String, dynamic>? session = _store.getSessionByEmail(
      normalizedEmail,
    );
    if (session == null) {
      return null;
    }
    return <String, dynamic>{
      'session': session,
      'source': 'local-rest-backend',
    };
  }

  Future<Map<String, dynamic>> syncAuthentication(
    Map<String, dynamic> payload,
  ) async {
    final Map<String, dynamic> userProfile = RequestValidator.requireMap(
      payload,
      'userProfile',
    );
    final String email = RequestValidator.requireEmail(userProfile['email'] as String?);
    final bool isAuthenticated = RequestValidator.requireBool(
      payload,
      'isAuthenticated',
      fallback: true,
    );
    await _store.upsertAuthentication(
      email: email,
      userProfile: userProfile,
      isAuthenticated: isAuthenticated,
    );
    return const <String, dynamic>{'status': 'synced', 'domain': 'auth'};
  }

  Future<Map<String, dynamic>> syncFavorites(Map<String, dynamic> payload) async {
    final _UserEnvelope envelope = _readEnvelope(payload);
    await _store.updateFavorites(
      email: envelope.email,
      userProfile: envelope.userProfile,
      restaurantIds: RequestValidator.stringList(payload, 'restaurantIds'),
      dishIds: RequestValidator.stringList(payload, 'dishIds'),
    );
    return const <String, dynamic>{'status': 'synced', 'domain': 'favorites'};
  }

  Future<Map<String, dynamic>> syncCart(Map<String, dynamic> payload) async {
    final _UserEnvelope envelope = _readEnvelope(payload);
    await _store.updateCart(
      email: envelope.email,
      userProfile: envelope.userProfile,
      items: RequestValidator.objectList(payload, 'items'),
    );
    return const <String, dynamic>{'status': 'synced', 'domain': 'cart'};
  }

  Future<Map<String, dynamic>> syncReservations(
    Map<String, dynamic> payload,
  ) async {
    final _UserEnvelope envelope = _readEnvelope(payload);
    await _store.updateReservations(
      email: envelope.email,
      userProfile: envelope.userProfile,
      reservations: RequestValidator.objectList(payload, 'reservations'),
    );
    return const <String, dynamic>{
      'status': 'synced',
      'domain': 'reservations',
    };
  }

  Future<Map<String, dynamic>> syncOrders(Map<String, dynamic> payload) async {
    final _UserEnvelope envelope = _readEnvelope(payload);
    await _store.updateOrders(
      email: envelope.email,
      userProfile: envelope.userProfile,
      orders: RequestValidator.objectList(payload, 'orders'),
    );
    return const <String, dynamic>{'status': 'synced', 'domain': 'orders'};
  }

  _UserEnvelope _readEnvelope(Map<String, dynamic> payload) {
    final Map<String, dynamic> userProfile = RequestValidator.requireMap(
      payload,
      'userProfile',
    );
    final String email = RequestValidator.requireEmail(
      (payload['userEmail'] as String?) ?? (userProfile['email'] as String?),
      fieldName: 'userEmail',
    );
    return _UserEnvelope(email: email, userProfile: userProfile);
  }
}

class _UserEnvelope {
  const _UserEnvelope({required this.email, required this.userProfile});

  final String email;
  final Map<String, dynamic> userProfile;
}
