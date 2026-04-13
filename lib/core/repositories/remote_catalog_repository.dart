import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';

abstract class RemoteCatalogRepository {
  Future<List<Restaurant>?> fetchRestaurants({CatalogQuery? query});

  Future<List<Dish>?> fetchDishes({CatalogQuery? query});
}
