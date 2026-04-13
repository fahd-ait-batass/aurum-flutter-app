import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final cartLines = appState.cartLines;
    final OrderReceipt? latestOrder = appState.orderHistory.isEmpty
        ? null
        : appState.orderHistory.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart & order')),
      body: cartLines.isEmpty
          ? _EmptyCartState(latestOrder: latestOrder)
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: <Widget>[
                const SectionHeader(
                  title: 'Tonight\'s order',
                  subtitle:
                      'Review premium plates, adjust quantities, then place the order.',
                ),
                const SizedBox(height: 14),
                ...cartLines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SurfaceCard(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: line.dish.gradientColors,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              line.dish.heroIcon,
                              color: const Color(0xFFF8F1E7),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  line.dish.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appState.restaurantById(line.dish.restaurantId).name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppFormatters.currencyMad(
                                    line.dish.priceMad * line.item.quantity,
                                  ),
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _QuantityStepper(dishId: line.dish.id),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SurfaceCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Order summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        label: 'Subtotal',
                        value: AppFormatters.currencyMad(appState.subtotalMad),
                      ),
                      const SizedBox(height: 10),
                      _SummaryRow(
                        label: 'Service fee',
                        value: AppFormatters.currencyMad(appState.serviceFeeMad),
                      ),
                      const SizedBox(height: 10),
                      _SummaryRow(
                        label: 'Delivery',
                        value: AppFormatters.currencyMad(appState.deliveryFeeMad),
                      ),
                      const Divider(height: 28),
                      _SummaryRow(
                        label: 'Total',
                        value: AppFormatters.currencyMad(appState.totalMad),
                        highlight: true,
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: () => AppNavigator.showCheckout(context),
                        child: const Text('Continue to checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.dishId});

  final String dishId;

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);
    final line = appState.cartLines.firstWhere((item) => item.dish.id == dishId);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171B23),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A303A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () => appState.updateCartItemQuantity(
              dishId,
              line.item.quantity - 1,
            ),
            icon: const Icon(Icons.remove_rounded),
          ),
          Text(
            '${line.item.quantity}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            onPressed: () => appState.updateCartItemQuantity(
              dishId,
              line.item.quantity + 1,
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = highlight
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: const Color(0xFFF6C56B))
        : Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFFF8F1E7),
          );

    return Row(
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState({required this.latestOrder});

  final OrderReceipt? latestOrder;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: <Widget>[
        FeedbackStateCard(
          icon: latestOrder == null
              ? Icons.shopping_bag_outlined
              : Icons.check_circle_rounded,
          title: latestOrder == null ? 'Your cart is empty' : 'Order placed',
          message: latestOrder == null
              ? 'Add a few premium dishes to begin an order.'
              : 'Reference ${latestOrder!.reference} is confirmed for ${AppFormatters.currencyMad(latestOrder!.totalMad)}.',
        ),
        if (latestOrder != null) ...<Widget>[
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Recent order',
            subtitle: 'The latest delivery you placed from this device.',
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  latestOrder!.reference,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '${latestOrder!.statusLabel} | ${latestOrder!.fulfillmentLabel}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  '${latestOrder!.itemsCount} items | ${AppFormatters.currencyMad(latestOrder!.totalMad)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
