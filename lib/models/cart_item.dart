import 'sneaker.dart';

class CartItem {
  final Sneaker sneaker;
  final int size;
  int quantity;

  CartItem({
    required this.sneaker,
    required this.size,
    this.quantity = 1,
  });

  double get totalPrice => sneaker.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'sneaker': sneaker.toMap(),
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      sneaker: Sneaker.fromMap(Map<String, dynamic>.from(map['sneaker'] ?? {})),
      size: (map['size'] as num?)?.toInt() ?? 8,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
