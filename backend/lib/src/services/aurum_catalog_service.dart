import 'package:aurum_backend/src/aurum_backend_store.dart';

class AurumCatalogService {
  const AurumCatalogService({required AurumBackendStore store}) : _store = store;

  final AurumBackendStore _store;

  List<Map<String, dynamic>> searchRestaurants({
    String search = '',
    String category = '',
  }) {
    final String normalizedSearch = search.trim().toLowerCase();
    final String normalizedCategory = category.trim().toLowerCase();

    return _store.restaurants.where((Map<String, dynamic> restaurant) {
      final List<String> categories = _store.readStringList(
        restaurant['categories'],
      );
      final List<String> highlights = _store.readStringList(
        restaurant['highlights'],
      );
      final bool matchesCategory = normalizedCategory.isEmpty ||
          (restaurant['cuisine'] as String? ?? '').toLowerCase().contains(
                normalizedCategory,
              ) ||
          categories.any(
            (String item) => item.toLowerCase().contains(normalizedCategory),
          );
      final bool matchesSearch = normalizedSearch.isEmpty ||
          (restaurant['name'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          (restaurant['cuisine'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          (restaurant['neighborhood'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          (restaurant['description'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          highlights.any(
            (String item) => item.toLowerCase().contains(normalizedSearch),
          );
      return matchesCategory && matchesSearch;
    }).map(_store.cloneMap).toList(growable: false);
  }

  List<Map<String, dynamic>> searchDishes({
    String search = '',
    String category = '',
  }) {
    final String normalizedSearch = search.trim().toLowerCase();
    final String normalizedCategory = category.trim().toLowerCase();
    final Map<String, Map<String, dynamic>> restaurantsById =
        <String, Map<String, dynamic>>{
          for (final Map<String, dynamic> restaurant in _store.restaurants)
            restaurant['id'] as String: restaurant,
        };

    return _store.dishes.where((Map<String, dynamic> dish) {
      final Map<String, dynamic> restaurant =
          restaurantsById[dish['restaurantId'] as String] ??
          const <String, dynamic>{};
      final List<String> restaurantCategories = _store.readStringList(
        restaurant['categories'],
      );
      final List<String> dietaryNotes = _store.readStringList(
        dish['dietaryNotes'],
      );
      final List<String> ingredients = _store.readStringList(
        dish['ingredients'],
      );
      final bool matchesCategory = normalizedCategory.isEmpty ||
          (restaurant['cuisine'] as String? ?? '').toLowerCase().contains(
                normalizedCategory,
              ) ||
          restaurantCategories.any(
            (String item) => item.toLowerCase().contains(normalizedCategory),
          ) ||
          dietaryNotes.any(
            (String item) => item.toLowerCase().contains(normalizedCategory),
          );
      final bool matchesSearch = normalizedSearch.isEmpty ||
          (dish['name'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          (dish['shortDescription'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          (dish['description'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          (restaurant['name'] as String? ?? '').toLowerCase().contains(
                normalizedSearch,
              ) ||
          ingredients.any(
            (String item) => item.toLowerCase().contains(normalizedSearch),
          );
      return matchesCategory && matchesSearch;
    }).map(_store.cloneMap).toList(growable: false);
  }
}
