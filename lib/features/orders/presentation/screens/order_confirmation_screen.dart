import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/order_receipt.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/feedback_state_card.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.receipt});

  final OrderReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order confirmed')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: <Widget>[
          FeedbackStateCard(
            icon: Icons.check_circle_rounded,
            title: 'Order ${receipt.reference} is confirmed',
            message:
                'Your ${receipt.fulfillmentLabel.toLowerCase()} is set and the order total is ${AppFormatters.currencyMad(receipt.totalMad)}.',
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Confirmation details',
            subtitle: 'A clear summary for the next step in the order flow.',
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _InfoRow(label: 'Status', value: receipt.statusLabel),
                const SizedBox(height: 10),
                _InfoRow(label: 'Fulfillment', value: receipt.fulfillmentLabel),
                const SizedBox(height: 10),
                _InfoRow(label: 'Payment', value: receipt.paymentLabel),
                const SizedBox(height: 10),
                _InfoRow(
                  label: 'Placed',
                  value: AppFormatters.compactDate(receipt.placedAt),
                ),
                if (receipt.orderNote.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Note', value: receipt.orderNote),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 96,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
