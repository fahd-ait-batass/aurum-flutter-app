import 'dart:convert';

import 'package:flutter_app/core/models/local_app_snapshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAppStorage {
  static const String _storageKey = 'aurum_table_state_v1';

  Future<LocalAppSnapshot?> load() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? raw = preferences.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      return LocalAppSnapshot.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(LocalAppSnapshot snapshot) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, jsonEncode(snapshot.toJson()));
  }
}
