import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/features/home/data/home_seed_data.dart';
import 'package:flutter_app/features/home/presentation/widgets/featured_experience_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/nearby_restaurant_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/popular_dish_card.dart';
import 'package:flutter_app/features/home/presentation/widgets/quick_action_tile.dart';
import 'package:flutter_app/features/home/presentation/widgets/welcome_header.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';
import 'package:flutter_app/shared/widgets/premium_search_bar.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/selectable_filter_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;
  String _selectedCategory = 'Signature';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final Restaurant featuredRestaurant = appState.featuredRestaurant;
    final CatalogQuery query = CatalogQuery(
      searchText: _searchController.text,
      category: _selectedCategory == 'Signature' ? null : _selectedCategory,
    );
    final List<Dish> searchableDishes = appState.searchDishes(query);
    final List<Restaurant> searchableRestaurants = appState.searchRestaurants(
      query,
    );
    final Set<String> searchableDishIds = searchableDishes
        .map((Dish item) => item.id)
        .toSet();
    final Set<String> searchableRestaurantIds = searchableRestaurants
        .map((Restaurant item) => item.id)
        .toSet();
    final List<Dish> filteredPopularDishes = appState.popularDishes
        .where((Dish item) => searchableDishIds.contains(item.id))
        .toList(growable: false);
    final List<Restaurant> filteredNearbyRestaurants = appState.nearbyRestaurants
        .where((Restaurant item) => searchableRestaurantIds.contains(item.id))
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: <Widget>[
        const WelcomeHeader(),
        const SizedBox(height: 20),
        PremiumSearchBar(
          controller: _searchController,
          hintText: 'Search tasting menus, dishes, or restaurants',
          onChanged: (_) => setState(() {}),
          onClear: () {
            _searchController.clear();
            setState(() {});
          },
        ),
        const SizedBox(height: 22),
        FeaturedExperienceCard(
          restaurant: featuredRestaurant,
          onReserve: () => AppNavigator.showReservation(
            context,
            restaurantId: featuredRestaurant.id,
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Explore cuisine',
          subtitle: 'Filter the catalog by dinner mood, cuisine, and ingredient profile.',
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cuisineCategories
                .map(
                  (CuisineCategory item) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SelectableFilterChip(
                      label: item.label,
                      icon: item.icon,
                      selected: _selectedCategory == item.label,
                      onTap: () => setState(() => _selectedCategory = item.label),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        if (query.hasSearchText) ...<Widget>[
          const SizedBox(height: 18),
          Text(
            'Showing results for "${_searchController.text.trim()}"',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Popular tonight',
          subtitle: 'Rich plates with a premium finish and strong ratings.',
          actionLabel: 'See menu',
          onActionPressed: () => AppNavigator.showRestaurantDetails(
            context,
            restaurantId: featuredRestaurant.id,
          ),
        ),
        const SizedBox(height: 14),
        if (filteredPopularDishes.isEmpty)
          const FeedbackStateCard(
            icon: Icons.search_off_rounded,
            title: 'No dishes match this search',
            message:
                'Try another cuisine or clear the query to bring back the chef picks.',
          )
        else
          SizedBox(
            height: 344,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filteredPopularDishes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (BuildContext context, int index) {
                final Dish dish = filteredPopularDishes[index];
                return PopularDishCard(
                  dish: dish,
                  restaurantName: appState.restaurantById(dish.restaurantId).name,
                  isFavorite: appState.isDishFavorite(dish.id),
                  onTap: () => AppNavigator.showDishDetails(context, dishId: dish.id),
                  onFavoriteTap: () => appState.toggleDishFavorite(dish.id),
                  onAddTap: () => appState.addDishToCart(dish.id),
                );
              },
            ),
          ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Quick actions',
          subtitle: 'Move from browsing to booking without friction.',
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 196,
          ),
          itemCount: homeQuickActions.length,
          itemBuilder: (BuildContext context, int index) {
            final QuickActionItem item = homeQuickActions[index];
            return QuickActionTile(
              item: item,
              onTap: () => _handleQuickAction(context, item),
            );
          },
        ),
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Close to you',
          subtitle: 'Elegant dining rooms with strong atmosphere nearby.',
          actionLabel: 'Saved',
          onActionPressed: () => AppNavigator.showFavorites(context),
        ),
        const SizedBox(height: 14),
        if (filteredNearbyRestaurants.isEmpty)
          const FeedbackStateCard(
            icon: Icons.place_outlined,
            title: 'No nearby restaurants found',
            message:
                'Adjust the search or category filter to reopen nearby dining suggestions.',
          )
        else
          ...filteredNearbyRestaurants.map(
            (Restaurant restaurant) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: NearbyRestaurantCard(
                restaurant: restaurant,
                isFavorite: appState.isRestaurantFavorite(restaurant.id),
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
    );
  }

  Future<void> _handleQuickAction(BuildContext context, QuickActionItem item) {
    switch (item.target) {
      case HomeQuickActionTarget.reservation:
        return AppNavigator.showReservation(
          context,
          restaurantId: item.restaurantId ?? 'aurum_lounge',
        );
      case HomeQuickActionTarget.cart:
        return AppNavigator.showCart(context);
      case HomeQuickActionTarget.favorites:
        return AppNavigator.showFavorites(context);
      case HomeQuickActionTarget.featuredRestaurant:
        return AppNavigator.showRestaurantDetails(
          context,
          restaurantId: item.restaurantId ?? 'aurum_lounge',
        );
    }
  }
}
