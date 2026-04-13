import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/features/discover/presentation/screens/discover_screen.dart';
import 'package:flutter_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_app/shared/widgets/app_bottom_navigation.dart';
import 'package:flutter_app/shared/widgets/icon_action_badge_button.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>['Home', 'Discover', 'Profile'];

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    DiscoverScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 74,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFFF6C56B), Color(0xFFE0843D)],
              ),
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: Color(0xFF221507),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Aurum Table'),
            Text(
              _titles[_selectedIndex],
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFF908A82),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconActionBadgeButton(
            icon: Icons.favorite_border_rounded,
            count: appState.favoriteCount,
            tooltip: 'Favorites',
            onPressed: () => AppNavigator.showFavorites(context),
          ),
          IconActionBadgeButton(
            icon: Icons.shopping_bag_outlined,
            count: appState.cartCount,
            tooltip: 'Cart',
            onPressed: () => AppNavigator.showCart(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF1D212A),
              child: Text(
                appState.userProfile.initials,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
