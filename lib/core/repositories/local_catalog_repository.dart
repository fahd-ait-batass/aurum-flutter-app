import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/repositories/catalog_repository.dart';

class LocalCatalogRepository implements CatalogRepository {
  LocalCatalogRepository({
    required List<Restaurant> restaurants,
    required List<Dish> dishes,
  }) : _restaurants = List<Restaurant>.from(restaurants),
       _dishes = List<Dish>.from(dishes);

  List<Restaurant> _restaurants;
  List<Dish> _dishes;

  @override
  List<Restaurant> get restaurants => List<Restaurant>.unmodifiable(_restaurants);

  @override
  List<Dish> get dishes => List<Dish>.unmodifiable(_dishes);

  @override
  void replaceCatalog({
    required List<Restaurant> restaurants,
    required List<Dish> dishes,
  }) {
    _restaurants = List<Restaurant>.from(restaurants);
    _dishes = List<Dish>.from(dishes);
  }

  @override
  Restaurant findRestaurantById(String restaurantId) {
    return _restaurants.firstWhere((Restaurant item) => item.id == restaurantId);
  }

  @override
  Dish findDishById(String dishId) {
    return _dishes.firstWhere((Dish item) => item.id == dishId);
  }

  @override
  List<Dish> dishesForRestaurant(String restaurantId) {
    return _dishes
        .where((Dish item) => item.restaurantId == restaurantId)
        .toList(growable: false);
  }

  @override
  List<Restaurant> searchRestaurants(CatalogQuery query) {
    final String normalizedQuery = query.searchText.trim().toLowerCase();
    final String normalizedCategory = (query.category ?? '').trim().toLowerCase();

    return _restaurants.where((Restaurant restaurant) {
      final bool matchesCategory = normalizedCategory.isEmpty ||
          restaurant.cuisine.toLowerCase().contains(normalizedCategory) ||
          restaurant.categories.any(
            (String item) => item.toLowerCase().contains(normalizedCategory),
          );
      final bool matchesQuery = normalizedQuery.isEmpty ||
          restaurant.name.toLowerCase().contains(normalizedQuery) ||
          restaurant.cuisine.toLowerCase().contains(normalizedQuery) ||
          restaurant.neighborhood.toLowerCase().contains(normalizedQuery) ||
          restaurant.description.toLowerCase().contains(normalizedQuery) ||
          restaurant.highlights.any(
            (String item) => item.toLowerCase().contains(normalizedQuery),
          );

      return matchesCategory && matchesQuery;
    }).toList(growable: false);
  }

  @override
  List<Dish> searchDishes(CatalogQuery query) {
    final String normalizedQuery = query.searchText.trim().toLowerCase();
    final String normalizedCategory = (query.category ?? '').trim().toLowerCase();

    return _dishes.where((Dish dish) {
      final Restaurant restaurant = _restaurants.firstWhere(
        (Restaurant item) => item.id == dish.restaurantId,
      );
      final bool matchesCategory = normalizedCategory.isEmpty ||
          restaurant.cuisine.toLowerCase().contains(normalizedCategory) ||
          restaurant.categories.any(
            (String item) => item.toLowerCase().contains(normalizedCategory),
          ) ||
          dish.dietaryNotes.any(
            (String item) => item.toLowerCase().contains(normalizedCategory),
          );
      final bool matchesQuery = normalizedQuery.isEmpty ||
          dish.name.toLowerCase().contains(normalizedQuery) ||
          dish.shortDescription.toLowerCase().contains(normalizedQuery) ||
          dish.description.toLowerCase().contains(normalizedQuery) ||
          restaurant.name.toLowerCase().contains(normalizedQuery) ||
          dish.ingredients.any(
            (String item) => item.toLowerCase().contains(normalizedQuery),
          );

      return matchesCategory && matchesQuery;
    }).toList(growable: false);
  }
}
