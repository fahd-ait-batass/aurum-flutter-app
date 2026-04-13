import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/shared/widgets/restaurant_showcase_card.dart';

class NearbyRestaurantCard extends StatelessWidget {
  const NearbyRestaurantCard({
    super.key,
    required this.restaurant,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  final Restaurant restaurant;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return RestaurantShowcaseCard(
      restaurant: restaurant,
      height: 136,
      isFavorite: isFavorite,
      onTap: onTap,
      onFavoriteTap: onFavoriteTap,
    );
  }
}
