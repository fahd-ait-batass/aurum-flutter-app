import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/detail_metric_tile.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class DishDetailsScreen extends StatefulWidget {
  const DishDetailsScreen({super.key, required this.dishId});

  final String dishId;

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final Dish dish = appState.dishById(widget.dishId);
    final Restaurant restaurant = appState.restaurantById(dish.restaurantId);
    final bool isFavorite = appState.isDishFavorite(dish.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(dish.name),
        actions: <Widget>[
          IconButton(
            onPressed: () => appState.toggleDishFavorite(dish.id),
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
          child: SurfaceCard(
            radius: 28,
            padding: const EdgeInsets.all(16),
            backgroundColor: const Color(0xFF11141B),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF171B23),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF2A303A)),
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity -= 1)
                            : null,
                        icon: const Icon(Icons.remove_rounded),
                      ),
                      Text(
                        '$_quantity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () => setState(() => _quantity += 1),
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      appState.addDishToCart(dish.id, quantity: _quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${dish.name} added to cart (${_quantity}x)',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Add ${AppFormatters.currencyMad(dish.priceMad * _quantity)}',
                    ),
                  ),
                ),
              ],
            ),
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
                      colors: dish.gradientColors,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 0,
                        bottom: -8,
                        child: Icon(
                          dish.heroIcon,
                          size: 128,
                          color: const Color(0xFFF8F1E7).withValues(alpha: 0.22),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          StatusChip(
                            label: dish.badgeLabel,
                            icon: Icons.restaurant_menu_rounded,
                            backgroundColor: const Color(0x29151821),
                            foregroundColor: const Color(0xFFF6C56B),
                            borderColor: const Color(0x554A3422),
                          ),
                          const Spacer(),
                          Text(
                            dish.name,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(fontSize: 34),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dish.shortDescription,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        AppFormatters.currencyMad(dish.priceMad),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => AppNavigator.showRestaurantDetails(
                          context,
                          restaurantId: restaurant.id,
                        ),
                        child: Text(restaurant.name),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(dish.description, style: Theme.of(context).textTheme.bodyLarge),
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
                value: dish.rating.toStringAsFixed(1),
                icon: Icons.star_rounded,
              ),
              DetailMetricTile(
                label: 'Prep time',
                value: '${dish.prepMinutes} min',
                icon: Icons.schedule_rounded,
              ),
              DetailMetricTile(
                label: 'Calories',
                value: '${dish.calories}',
                icon: Icons.bolt_rounded,
              ),
              DetailMetricTile(
                label: 'Dining room',
                value: restaurant.neighborhood,
                icon: Icons.place_rounded,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: dish.ingredients
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
          Text('Notes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: dish.dietaryNotes
                .map(
                  (String item) => StatusChip(
                    label: item,
                    icon: Icons.info_outline_rounded,
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
