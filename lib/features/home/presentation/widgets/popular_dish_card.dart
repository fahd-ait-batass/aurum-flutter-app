import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/shared/widgets/dish_showcase_card.dart';

class PopularDishCard extends StatelessWidget {
  const PopularDishCard({
    super.key,
    required this.dish,
    required this.restaurantName,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.onAddTap,
  });

  final Dish dish;
  final String restaurantName;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return DishShowcaseCard(
      width: 236,
      dish: dish,
      restaurantName: restaurantName,
      isFavorite: isFavorite,
      onTap: onTap,
      onFavoriteTap: onFavoriteTap,
      onAddTap: onAddTap,
    );
  }
}
