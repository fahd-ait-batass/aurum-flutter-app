import 'dart:math';

import 'package:flutter_app/core/models/app_session_state.dart';

class AuthService {
  const AuthService();

  AppSessionState signIn(
    AppSessionState session, {
    required String name,
    required String email,
  }) {
    return session.copyWith(
      isAuthenticated: true,
      userProfile: session.userProfile.copyWith(
        name: name,
        email: email,
        initials: _buildInitials(name),
      ),
    );
  }

  AppSessionState signOut(AppSessionState session) {
    return session.copyWith(isAuthenticated: false);
  }

  String buildInitials(String name) => _buildInitials(name);

  static String _buildInitials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) {
      return 'AT';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, min(2, parts.first.length)).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
