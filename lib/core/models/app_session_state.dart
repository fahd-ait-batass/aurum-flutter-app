import 'package:flutter_app/core/models/cart_item.dart';
import 'package:flutter_app/core/models/local_app_snapshot.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/user_profile.dart';

class AppSessionState {
  const AppSessionState({
    required this.isAuthenticated,
    required this.userProfile,
    required this.favoriteRestaurantIds,
    required this.favoriteDishIds,
    required this.cartItems,
    required this.reservations,
    required this.orderHistory,
  });

  final bool isAuthenticated;
  final UserProfile userProfile;
  final Set<String> favoriteRestaurantIds;
  final Set<String> favoriteDishIds;
  final List<CartItem> cartItems;
  final List<Reservation> reservations;
  final List<OrderReceipt> orderHistory;

  AppSessionState copyWith({
    bool? isAuthenticated,
    UserProfile? userProfile,
    Set<String>? favoriteRestaurantIds,
    Set<String>? favoriteDishIds,
    List<CartItem>? cartItems,
    List<Reservation>? reservations,
    List<OrderReceipt>? orderHistory,
  }) {
    return AppSessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userProfile: userProfile ?? this.userProfile,
      favoriteRestaurantIds:
          favoriteRestaurantIds ?? Set<String>.from(this.favoriteRestaurantIds),
      favoriteDishIds:
          favoriteDishIds ?? Set<String>.from(this.favoriteDishIds),
      cartItems: cartItems ?? List<CartItem>.from(this.cartItems),
      reservations: reservations ?? List<Reservation>.from(this.reservations),
      orderHistory: orderHistory ?? List<OrderReceipt>.from(this.orderHistory),
    );
  }

  LocalAppSnapshot toSnapshot() {
    return LocalAppSnapshot(
      isAuthenticated: isAuthenticated,
      userProfile: userProfile,
      favoriteRestaurantIds: favoriteRestaurantIds,
      favoriteDishIds: favoriteDishIds,
      cartItems: cartItems,
      reservations: reservations,
      orderHistory: orderHistory,
    );
  }

  Map<String, dynamic> toJson() => toSnapshot().toJson();

  factory AppSessionState.fromSnapshot(LocalAppSnapshot snapshot) {
    return AppSessionState(
      isAuthenticated: snapshot.isAuthenticated,
      userProfile: snapshot.userProfile,
      favoriteRestaurantIds: Set<String>.from(snapshot.favoriteRestaurantIds),
      favoriteDishIds: Set<String>.from(snapshot.favoriteDishIds),
      cartItems: List<CartItem>.from(snapshot.cartItems),
      reservations: List<Reservation>.from(snapshot.reservations),
      orderHistory: List<OrderReceipt>.from(snapshot.orderHistory),
    );
  }

  factory AppSessionState.fromJson(Map<String, dynamic> json) {
    return AppSessionState.fromSnapshot(LocalAppSnapshot.fromJson(json));
  }
}
