import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/widgets/detail_metric_tile.dart';
import 'package:flutter_app/shared/widgets/dish_showcase_card.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  const RestaurantDetailsScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final Restaurant restaurant = appState.restaurantById(restaurantId);
    final List<Dish> dishes = appState.dishesForRestaurant(restaurantId);
    final bool isFavorite = appState.isRestaurantFavorite(restaurantId);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: <Widget>[
          IconButton(
            onPressed: () => appState.toggleRestaurantFavorite(restaurantId),
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite ? const Color(0xFFFF8B5C) : null,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () => AppNavigator.showCart(context),
                  child: const Text('View cart'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => AppNavigator.showReservation(
                    context,
                    restaurantId: restaurant.id,
                  ),
                  child: const Text('Reserve'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: <Widget>[
          SurfaceCard(
            padding: EdgeInsets.zero,
            radius: 34,
            borderColor: const Color(0xFF4A3422),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(34),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: restaurant.gradientColors,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 0,
                        bottom: -8,
                        child: Icon(
                          restaurant.heroIcon,
                          size: 128,
                          color: const Color(0xFFF8F1E7).withValues(alpha: 0.18),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StatusChip(
                            label: restaurant.badgeLabel,
                            icon: Icons.auto_awesome_rounded,
                            backgroundColor: const Color(0x29151821),
                            foregroundColor: const Color(0xFFF6C56B),
                            borderColor: const Color(0x554A3422),
                          ),
                          const Spacer(),
                          Text(
                            restaurant.name,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(fontSize: 34),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${restaurant.cuisine} | ${restaurant.neighborhood}',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color: const Color(0xFFF6C56B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            restaurant.moodLine,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: restaurant.categories
                        .map((String item) => StatusChip(label: item))
                        .toList(growable: false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'About the room',
            subtitle: 'A refined look at the setting, service, and dining rhythm.',
          ),
          const SizedBox(height: 14),
          Text(
            restaurant.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 22),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: <Widget>[
              DetailMetricTile(
                label: 'Rating',
                value: restaurant.rating.toStringAsFixed(1),
                icon: Icons.star_rounded,
              ),
              DetailMetricTile(
                label: 'Reviews',
                value: '${restaurant.reviewCount}',
                icon: Icons.forum_rounded,
              ),
              DetailMetricTile(
                label: 'Distance',
                value: restaurant.distanceLabel,
                icon: Icons.place_rounded,
              ),
              DetailMetricTile(
                label: 'Delivery',
                value: restaurant.deliveryTimeLabel,
                icon: Icons.delivery_dining_rounded,
              ),
            ],
          ),
          const SizedBox(height: 28),
          SectionHeader(
            title: 'Chef selections',
            subtitle: 'Signature plates that define the restaurant right now.',
            actionLabel: 'Book table',
            onActionPressed: () => AppNavigator.showReservation(
              context,
              restaurantId: restaurant.id,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 332,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dishes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (BuildContext context, int index) {
                final Dish dish = dishes[index];
                return DishShowcaseCard(
                  width: 248,
                  dish: dish,
                  restaurantName: restaurant.name,
                  isFavorite: appState.isDishFavorite(dish.id),
                  onTap: () => AppNavigator.showDishDetails(
                    context,
                    dishId: dish.id,
                  ),
                  onFavoriteTap: () => appState.toggleDishFavorite(dish.id),
                  onAddTap: () {
                    appState.addDishToCart(dish.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${dish.name} added to cart')),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'What sets it apart',
            subtitle: 'Atmosphere and service details guests keep coming back for.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: restaurant.highlights
                .map(
                  (String item) => StatusChip(
                    label: item,
                    backgroundColor: const Color(0xFF171B23),
                    foregroundColor: const Color(0xFFE8E0D5),
                    borderColor: const Color(0xFF2B313C),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Prime slots',
            subtitle: 'Tonight’s best reservation windows.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: restaurant.availableSlots
                .map(
                  (String item) => StatusChip(
                    label: item,
                    icon: Icons.schedule_rounded,
                    backgroundColor: const Color(0xFF241B12),
                    foregroundColor: const Color(0xFFF6C56B),
                    borderColor: const Color(0xFF4A3320),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
