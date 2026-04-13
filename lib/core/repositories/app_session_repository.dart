import 'package:flutter_app/core/models/app_session_state.dart';

abstract class AppSessionRepository {
  Future<AppSessionState?> loadSession();

  Future<void> saveSession(AppSessionState session);
}
