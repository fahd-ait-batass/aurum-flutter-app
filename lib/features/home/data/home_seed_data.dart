import 'package:flutter/material.dart';

class CuisineCategory {
  const CuisineCategory({
    required this.label,
    required this.icon,
    this.isHighlighted = false,
  });

  final String label;
  final IconData icon;
  final bool isHighlighted;
}

enum HomeQuickActionTarget { reservation, cart, favorites, featuredRestaurant }

class QuickActionItem {
  const QuickActionItem({
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
  final HomeQuickActionTarget target;
  final String? restaurantId;
}

const List<CuisineCategory> cuisineCategories = <CuisineCategory>[
  CuisineCategory(
    label: 'Signature',
    icon: Icons.local_fire_department_rounded,
    isHighlighted: true,
  ),
  CuisineCategory(label: 'Sushi', icon: Icons.set_meal_rounded),
  CuisineCategory(label: 'Steak', icon: Icons.outdoor_grill_rounded),
  CuisineCategory(label: 'Seafood', icon: Icons.phishing_rounded),
  CuisineCategory(label: 'Dessert', icon: Icons.icecream_rounded),
];

const List<QuickActionItem> homeQuickActions = <QuickActionItem>[
  QuickActionItem(
    title: 'Book a table',
    subtitle: 'Reserve tonight in two taps.',
    icon: Icons.event_seat_rounded,
    accentColor: Color(0xFFF6B756),
    target: HomeQuickActionTarget.reservation,
    restaurantId: 'aurum_lounge',
  ),
  QuickActionItem(
    title: 'Your cart',
    subtitle: 'Review tonight’s order flow.',
    icon: Icons.shopping_bag_rounded,
    accentColor: Color(0xFFE58F4B),
    target: HomeQuickActionTarget.cart,
  ),
  QuickActionItem(
    title: 'Saved places',
    subtitle: 'Your favorite rooms and dishes.',
    icon: Icons.favorite_rounded,
    accentColor: Color(0xFFFF8B5C),
    target: HomeQuickActionTarget.favorites,
  ),
  QuickActionItem(
    title: 'Private dining',
    subtitle: 'Explore the signature room details.',
    icon: Icons.wine_bar_rounded,
    accentColor: Color(0xFFE0B15D),
    target: HomeQuickActionTarget.featuredRestaurant,
    restaurantId: 'maison_du_feu',
  ),
];
