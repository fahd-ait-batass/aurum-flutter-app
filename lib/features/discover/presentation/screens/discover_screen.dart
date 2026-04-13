import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/catalog_query.dart';
import 'package:flutter_app/core/models/dish.dart';
import 'package:flutter_app/core/models/restaurant.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/features/discover/data/discover_seed_data.dart';
import 'package:flutter_app/shared/widgets/dish_showcase_card.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';
import 'package:flutter_app/shared/widgets/premium_search_bar.dart';
import 'package:flutter_app/shared/widgets/restaurant_showcase_card.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/selectable_filter_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final TextEditingController _searchController;
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedFilter = discoverFilters.firstWhere((item) => item.isActive).label;
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
    final CatalogQuery query = CatalogQuery(
      searchText: _searchController.text,
      category: _selectedFilter == 'Open now' ? null : _selectedFilter,
    );
    final List<Restaurant> restaurants = appState.searchRestaurants(query);
    final List<Dish> dishes = appState.searchDishes(query).take(3).toList(
          growable: false,
        );
    final Restaurant? spotlight = restaurants.isEmpty ? null : restaurants.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: <Widget>[
        Text(
          'Find the room that matches tonight.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Search refined dining spots, rooftop tables, and chef-led experiences across the city.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        PremiumSearchBar(
          controller: _searchController,
          hintText: 'Search by cuisine, neighborhood, or atmosphere',
          onChanged: (_) => setState(() {}),
          onClear: () {
            _searchController.clear();
            setState(() {});
          },
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: discoverFilters
                .map(
                  (DiscoverFilter filter) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SelectableFilterChip(
                      label: filter.label,
                      selected: _selectedFilter == filter.label,
                      onTap: () => setState(() => _selectedFilter = filter.label),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 22),
        if (spotlight != null)
          SurfaceCard(
            radius: 30,
            padding: const EdgeInsets.all(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: spotlight.gradientColors,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${restaurants.length} matches ready to browse',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFFF6C56B),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${spotlight.name} leads the current search results.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  spotlight.moodLine,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          )
        else
          const FeedbackStateCard(
            icon: Icons.search_off_rounded,
            title: 'No restaurants match your search',
            message:
                'Try another query or filter to reopen the premium dining catalog.',
          ),
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Featured restaurants',
          subtitle:
              'Search results stay polished while still feeling rich and browsable.',
        ),
        const SizedBox(height: 14),
        if (restaurants.isEmpty)
          const FeedbackStateCard(
            icon: Icons.table_bar_outlined,
            title: 'Nothing to show yet',
            message:
                'Clear the current filters and the restaurant collection will repopulate instantly.',
          )
        else
          ...restaurants.map(
            (Restaurant restaurant) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: RestaurantShowcaseCard(
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
        const SizedBox(height: 28),
        const SectionHeader(
          title: 'Matching dishes',
          subtitle: 'Search also reaches dishes so the menu feels part of the product.',
        ),
        const SizedBox(height: 14),
        if (dishes.isEmpty)
          const FeedbackStateCard(
            icon: Icons.no_food_rounded,
            title: 'No dish results yet',
            message:
                'Adjust the search terms to surface matching plates and menu highlights.',
          )
        else
          ...dishes.map(
            (Dish dish) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DishShowcaseCard(
                dish: dish,
                restaurantName: appState.restaurantById(dish.restaurantId).name,
                isFavorite: appState.isDishFavorite(dish.id),
                onTap: () => AppNavigator.showDishDetails(context, dishId: dish.id),
                onFavoriteTap: () => appState.toggleDishFavorite(dish.id),
                onAddTap: () => appState.addDishToCart(dish.id),
              ),
            ),
          ),
      ],
    );
  }
}
