import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';
import 'package:flutter_app/shared/widgets/dish_showcase_card.dart';
import 'package:flutter_app/shared/widgets/restaurant_showcase_card.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final List<Restaurant> favoriteRestaurants = appState.favoriteRestaurants;
    final List<Dish> favoriteDishes = appState.favoriteDishes;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favoriteRestaurants.isEmpty && favoriteDishes.isEmpty
          ? const _EmptyFavoritesState()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: <Widget>[
                if (favoriteRestaurants.isNotEmpty) ...<Widget>[
                  const SectionHeader(
                    title: 'Saved restaurants',
                    subtitle: 'The dining rooms worth revisiting first.',
                  ),
                  const SizedBox(height: 14),
                  ...favoriteRestaurants.map(
                    (Restaurant restaurant) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: RestaurantShowcaseCard(
                        restaurant: restaurant,
                        isFavorite: true,
                        onTap: () => AppNavigator.showRestaurantDetails(
                          context,
                          restaurantId: restaurant.id,
                        ),
                        onFavoriteTap: () =>
                            appState.toggleRestaurantFavorite(restaurant.id),
                      ),
                    ),
                  ),
                ],
                if (favoriteDishes.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 14),
                  const SectionHeader(
                    title: 'Saved dishes',
                    subtitle: 'Signature plates waiting for your next order.',
                  ),
                  const SizedBox(height: 14),
                  ...favoriteDishes.map(
                    (Dish dish) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: DishShowcaseCard(
                        dish: dish,
                        restaurantName:
                            appState.restaurantById(dish.restaurantId).name,
                        isFavorite: true,
                        onTap: () => AppNavigator.showDishDetails(
                          context,
                          dishId: dish.id,
                        ),
                        onFavoriteTap: () => appState.toggleDishFavorite(dish.id),
                        onAddTap: () => appState.addDishToCart(dish.id),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: FeedbackStateCard(
          icon: Icons.favorite_border_rounded,
          title: 'No favorites yet',
          message:
              'Save dining rooms and dishes to keep the best options one tap away.',
        ),
      ),
    );
  }
}
