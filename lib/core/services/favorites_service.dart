import 'package:flutter_app/core/models/app_session_state.dart';

class FavoritesService {
  const FavoritesService();

  AppSessionState toggleRestaurantFavorite(
    AppSessionState session,
    String restaurantId,
  ) {
    final Set<String> favorites = Set<String>.from(session.favoriteRestaurantIds);
    if (favorites.contains(restaurantId)) {
      favorites.remove(restaurantId);
    } else {
      favorites.add(restaurantId);
    }
    return session.copyWith(favoriteRestaurantIds: favorites);
  }

  AppSessionState toggleDishFavorite(AppSessionState session, String dishId) {
    final Set<String> favorites = Set<String>.from(session.favoriteDishIds);
    if (favorites.contains(dishId)) {
      favorites.remove(dishId);
    } else {
      favorites.add(dishId);
    }
    return session.copyWith(favoriteDishIds: favorites);
  }
}
