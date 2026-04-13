import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';

class RemoteCatalogSnapshot {
  const RemoteCatalogSnapshot({
    required this.restaurants,
    required this.dishes,
  });

  final List<Restaurant> restaurants;
  final List<Dish> dishes;

  bool get hasEntries => restaurants.isNotEmpty || dishes.isNotEmpty;
}
