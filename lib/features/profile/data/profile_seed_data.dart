import 'package:flutter/material.dart';

enum AccountShortcutTarget { cart, favorites, reservation, featuredRestaurant }

class AccountShortcut {
  const AccountShortcut({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.target,
    this.restaurantId,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final AccountShortcutTarget target;
  final String? restaurantId;
}

const List<AccountShortcut> accountShortcuts = <AccountShortcut>[
  AccountShortcut(
    title: 'Cart & active order',
    subtitle: 'Review tonight’s order, quantity changes, and checkout.',
    icon: Icons.shopping_bag_rounded,
    accentColor: Color(0xFFF6B756),
    target: AccountShortcutTarget.cart,
  ),
  AccountShortcut(
    title: 'Favorite restaurants',
    subtitle: 'Saved dining rooms and dishes you want close at hand.',
    icon: Icons.favorite_rounded,
    accentColor: Color(0xFFFF8B5C),
    target: AccountShortcutTarget.favorites,
  ),
  AccountShortcut(
    title: 'Manage reservation',
    subtitle: 'Open the current booking flow and confirm another table.',
    icon: Icons.event_available_rounded,
    accentColor: Color(0xFFE58F4B),
    target: AccountShortcutTarget.reservation,
    restaurantId: 'aurum_lounge',
  ),
  AccountShortcut(
    title: 'Chef room details',
    subtitle: 'Review the premium room reserved for private dining.',
    icon: Icons.room_service_rounded,
    accentColor: Color(0xFFE0B15D),
    target: AccountShortcutTarget.featuredRestaurant,
    restaurantId: 'maison_du_feu',
  ),
];
