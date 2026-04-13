import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';

abstract class CatalogRepository {
  List<Restaurant> get restaurants;

  List<Dish> get dishes;

  void replaceCatalog({
    required List<Restaurant> restaurants,
    required List<Dish> dishes,
  });

  Restaurant findRestaurantById(String restaurantId);

  Dish findDishById(String dishId);

  List<Dish> dishesForRestaurant(String restaurantId);

  List<Restaurant> searchRestaurants(CatalogQuery query);

  List<Dish> searchDishes(CatalogQuery query);
}
