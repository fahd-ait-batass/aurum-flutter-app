import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/cart_item.dart';

class CartService {
  const CartService();

  AppSessionState addDish(
    AppSessionState session,
    String dishId, {
    int quantity = 1,
  }) {
    final List<CartItem> items = List<CartItem>.from(session.cartItems);
    final int existingIndex = items.indexWhere(
      (CartItem item) => item.dishId == dishId,
    );
    if (existingIndex == -1) {
      items.add(CartItem(dishId: dishId, quantity: quantity));
    } else {
      final CartItem current = items[existingIndex];
      items[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    }
    return session.copyWith(cartItems: items);
  }

  AppSessionState updateDishQuantity(
    AppSessionState session,
    String dishId,
    int quantity,
  ) {
    final List<CartItem> items = List<CartItem>.from(session.cartItems);
    final int index = items.indexWhere((CartItem item) => item.dishId == dishId);
    if (index == -1) {
      return session;
    }
    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(quantity: quantity);
    }
    return session.copyWith(cartItems: items);
  }

  AppSessionState clearCart(AppSessionState session) {
    return session.copyWith(cartItems: <CartItem>[]);
  }
}
