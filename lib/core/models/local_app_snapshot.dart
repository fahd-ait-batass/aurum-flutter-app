import 'package:flutter_app/core/models/cart_item.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/core/models/reservation.dart';
import 'package:flutter_app/core/models/user_profile.dart';

class LocalAppSnapshot {
  const LocalAppSnapshot({
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isAuthenticated': isAuthenticated,
      'userProfile': userProfile.toJson(),
      'favoriteRestaurantIds': favoriteRestaurantIds.toList(),
      'favoriteDishIds': favoriteDishIds.toList(),
      'cartItems': cartItems.map((CartItem item) => item.toJson()).toList(),
      'reservations': reservations
          .map((Reservation item) => item.toJson())
          .toList(),
      'orderHistory': orderHistory
          .map((OrderReceipt item) => item.toJson())
          .toList(),
    };
  }

  factory LocalAppSnapshot.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawFavoriteRestaurants =
        json['favoriteRestaurantIds'] as List<dynamic>? ?? <dynamic>[];
    final List<dynamic> rawFavoriteDishes =
        json['favoriteDishIds'] as List<dynamic>? ?? <dynamic>[];
    final List<dynamic> rawCartItems =
        json['cartItems'] as List<dynamic>? ?? <dynamic>[];
    final List<dynamic> rawReservations =
        json['reservations'] as List<dynamic>? ?? <dynamic>[];
    final List<dynamic> rawOrderHistory =
        json['orderHistory'] as List<dynamic>? ?? <dynamic>[];

    return LocalAppSnapshot(
      isAuthenticated: json['isAuthenticated'] as bool? ?? true,
      userProfile: UserProfile.fromJson(
        json['userProfile'] as Map<String, dynamic>,
      ),
      favoriteRestaurantIds: rawFavoriteRestaurants
          .map((dynamic item) => item as String)
          .toSet(),
      favoriteDishIds: rawFavoriteDishes
          .map((dynamic item) => item as String)
          .toSet(),
      cartItems: rawCartItems
          .map((dynamic item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      reservations: rawReservations
          .map(
            (dynamic item) => Reservation.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      orderHistory: rawOrderHistory
          .map(
            (dynamic item) => OrderReceipt.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }
}
