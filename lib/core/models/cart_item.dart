class CartItem {
  const CartItem({required this.dishId, required this.quantity});

  final String dishId;
  final int quantity;

  CartItem copyWith({String? dishId, int? quantity}) {
    return CartItem(
      dishId: dishId ?? this.dishId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'dishId': dishId, 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      dishId: json['dishId'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
