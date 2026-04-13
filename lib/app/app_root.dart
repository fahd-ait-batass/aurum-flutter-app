import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_shell.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);

    if (!appState.isReady) {
      return const _BootstrapScreen();
    }

    if (appState.bootstrapError != null) {
      return _BootstrapErrorScreen(onRetry: () {
        appState.retryHydration();
      });
    }

    if (!appState.isAuthenticated) {
      return const SignInScreen();
    }

    return const AppShell();
  }
}

class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: FeedbackStateCard(
            icon: Icons.restaurant_menu_rounded,
            title: 'Preparing your table',
            message:
                'Restoring your favorites, cart, reservations, and account details on this device.',
          ),
        ),
      ),
    );
  }
}

class _BootstrapErrorScreen extends StatelessWidget {
  const _BootstrapErrorScreen({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FeedbackStateCard(
            icon: Icons.error_outline_rounded,
            title: 'Unable to restore local data',
            message:
                'The app could not rebuild its local session. Retry to recover your saved state on this device.',
            actionLabel: 'Retry',
            onActionPressed: onRetry,
            accentColor: const Color(0xFFFF8B5C),
          ),
        ),
      ),
    );
  }
}
