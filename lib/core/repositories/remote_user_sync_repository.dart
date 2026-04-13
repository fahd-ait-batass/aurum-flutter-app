import 'package:flutter_app/core/models/app_session_state.dart';

abstract class RemoteUserSyncRepository {
  Future<void> syncFavorites(AppSessionState session);

  Future<void> syncCart(AppSessionState session);

  Future<void> syncReservations(AppSessionState session);

  Future<void> syncOrders(AppSessionState session);
}
