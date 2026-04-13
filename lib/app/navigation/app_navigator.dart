import 'package:flutter/material.dart';
import 'package:flutter_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:flutter_app/features/dishes/presentation/screens/dish_details_screen.dart';
import 'package:flutter_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:flutter_app/features/orders/presentation/screens/checkout_screen.dart';
import 'package:flutter_app/features/orders/presentation/screens/order_confirmation_screen.dart';
import 'package:flutter_app/features/restaurants/presentation/screens/restaurant_details_screen.dart';
import 'package:flutter_app/features/reservations/presentation/screens/reservation_confirmation_screen.dart';
import 'package:flutter_app/features/reservations/presentation/screens/reservation_screen.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/restaurant.dart';

class AppNavigator {
  static Future<void> showRestaurantDetails(
    BuildContext context, {
    required String restaurantId,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RestaurantDetailsScreen(restaurantId: restaurantId),
      ),
    );
  }

  static Future<void> showDishDetails(
    BuildContext context, {
    required String dishId,
  }) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => DishDetailsScreen(dishId: dishId)));
  }

  static Future<void> showFavorites(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()));
  }

  static Future<void> showReservation(
    BuildContext context, {
    required String restaurantId,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReservationScreen(restaurantId: restaurantId),
      ),
    );
  }

  static Future<void> showCart(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
  }

  static Future<void> showCheckout(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CheckoutScreen()));
  }

  static Future<void> showOrderConfirmation(
    BuildContext context, {
    required OrderReceipt receipt,
  }) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OrderConfirmationScreen(receipt: receipt),
      ),
    );
  }

  static Future<void> showReservationConfirmation(
    BuildContext context, {
    required Reservation reservation,
    required Restaurant restaurant,
  }) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ReservationConfirmationScreen(
          reservation: reservation,
          restaurant: restaurant,
        ),
      ),
    );
  }
}
