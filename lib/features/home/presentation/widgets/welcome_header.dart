import 'package:flutter/material.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            StatusChip(
              label: appState.userProfile.city,
              icon: Icons.place_rounded,
            ),
            StatusChip(
              label: appState.userProfile.membershipTier,
              icon: Icons.workspace_premium_rounded,
              backgroundColor: Color(0xFF241B12),
              foregroundColor: Color(0xFFF6C56B),
              borderColor: Color(0xFF4A3320),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Good evening, ${appState.userProfile.name.split(' ').first}.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Your next polished table is ready. Favorites, reservations, and the active order are all live in the app now.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
