import 'package:flutter_app/core/models/app_session_state.dart';

abstract class RemoteAuthRepository {
  Future<AppSessionState?> restoreSession({
    required AppSessionState localSession,
  });

  Future<void> syncAuthentication(AppSessionState session);
}
