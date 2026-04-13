import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/local_app_snapshot.dart';
import 'package:flutter_app/core/repositories/app_session_repository.dart';
import 'package:flutter_app/core/storage/local_app_storage.dart';

class LocalAppSessionRepository implements AppSessionRepository {
  const LocalAppSessionRepository({required LocalAppStorage storage})
    : _storage = storage;

  final LocalAppStorage _storage;

  @override
  Future<AppSessionState?> loadSession() async {
    final LocalAppSnapshot? snapshot = await _storage.load();
    if (snapshot == null) {
      return null;
    }
    return AppSessionState.fromSnapshot(snapshot);
  }

  @override
  Future<void> saveSession(AppSessionState session) {
    return _storage.save(session.toSnapshot());
  }
}
