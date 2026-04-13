import 'package:flutter_app/core/models/cart_item.dart';

class OrderReceipt {
  const OrderReceipt({
    required this.reference,
    required this.placedAt,
    required this.itemsCount,
    required this.totalMad,
    required this.lineItems,
    required this.statusLabel,
    required this.fulfillmentLabel,
    this.paymentLabel = 'Visa **** 4421',
    this.orderNote = '',
  });

  final String reference;
  final DateTime placedAt;
  final int itemsCount;
  final double totalMad;
  final List<CartItem> lineItems;
  final String statusLabel;
  final String fulfillmentLabel;
  final String paymentLabel;
  final String orderNote;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'reference': reference,
      'placedAt': placedAt.toIso8601String(),
      'itemsCount': itemsCount,
      'totalMad': totalMad,
      'lineItems': lineItems.map((CartItem item) => item.toJson()).toList(),
      'statusLabel': statusLabel,
      'fulfillmentLabel': fulfillmentLabel,
      'paymentLabel': paymentLabel,
      'orderNote': orderNote,
    };
  }

  factory OrderReceipt.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems =
        json['lineItems'] as List<dynamic>? ?? <dynamic>[];
    return OrderReceipt(
      reference: json['reference'] as String,
      placedAt: DateTime.parse(json['placedAt'] as String),
      itemsCount: json['itemsCount'] as int,
      totalMad: (json['totalMad'] as num).toDouble(),
      lineItems: rawItems
          .map((dynamic item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      statusLabel: json['statusLabel'] as String? ?? 'Delivered',
      fulfillmentLabel: json['fulfillmentLabel'] as String? ?? 'Express delivery',
      paymentLabel: json['paymentLabel'] as String? ?? 'Visa **** 4421',
      orderNote: json['orderNote'] as String? ?? '',
    );
  }
}
