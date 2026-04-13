import 'dart:math';

import 'package:flutter_app/core/models/app_session_state.dart';
import 'package:flutter_app/core/models/cart_item.dart';
import 'package:flutter_app/core/models/order_receipt.dart';

class OrderMutationResult {
  const OrderMutationResult({required this.session, required this.receipt});

  final AppSessionState session;
  final OrderReceipt receipt;
}

class OrderService {
  const OrderService();

  OrderMutationResult? placeOrder(
    AppSessionState session, {
    required double totalMad,
    String fulfillmentLabel = 'Express delivery',
    String paymentLabel = 'Visa •••• 4421',
    String orderNote = '',
  }) {
    if (session.cartItems.isEmpty) {
      return null;
    }

    final List<CartItem> snapshotItems = session.cartItems
        .map((CartItem item) => item.copyWith())
        .toList(growable: false);
    final OrderReceipt receipt = OrderReceipt(
      reference: 'AT-${1000 + Random().nextInt(9000)}',
      placedAt: DateTime.now(),
      itemsCount: snapshotItems.fold<int>(
        0,
        (int sum, CartItem item) => sum + item.quantity,
      ),
      totalMad: totalMad,
      lineItems: snapshotItems,
      statusLabel: 'Confirmed',
      fulfillmentLabel: fulfillmentLabel,
      paymentLabel: paymentLabel,
      orderNote: orderNote,
    );

    final List<OrderReceipt> orderHistory = List<OrderReceipt>.from(
      session.orderHistory,
    )..insert(0, receipt);
    final AppSessionState updatedSession = session.copyWith(
      cartItems: <CartItem>[],
      orderHistory: orderHistory,
      userProfile: session.userProfile.copyWith(
        points: session.userProfile.points + totalMad.round(),
      ),
    );

    return OrderMutationResult(session: updatedSession, receipt: receipt);
  }
}
