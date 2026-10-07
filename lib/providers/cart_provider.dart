import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/notification_item.dart';
import '../models/sneaker.dart';
import '../data/mock_data.dart';
import 'notification_provider.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [
    // Pre-populate with Screen 10 items
    CartItem(sneaker: MockData.sneakers[1], size: 9, quantity: 1), // Nike Air Max 270 (12,999)
    CartItem(sneaker: MockData.sneakers[0], size: 10, quantity: 1), // Air Jordan 1 (14,999)
  ];

  String? _appliedPromo;
  double _discountPercent = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * _discountPercent;

  double get shippingFee => _items.isEmpty ? 0.0 : 0.0; // Free shipping

  double get total => subtotal - discountAmount + shippingFee;

  String? get appliedPromo => _appliedPromo;

  void addItem(Sneaker sneaker, int size, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.sneaker.id == sneaker.id && item.size == size,
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(sneaker: sneaker, size: size, quantity: quantity));
    }
    notifyListeners();

    NotificationProvider.send(
      title: 'Added to Cart 🛒',
      message: '${sneaker.name} (UK $size) added to your shopping cart.',
      type: NotificationType.cartUpdated,
    );
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    } else {
      removeItem(item);
    }
  }

  bool applyPromoCode(String code) {
    final upper = code.trim().toUpperCase();
    if (upper == 'SNEAKER20' || upper == 'SNEAKR20' || upper == 'DISCOUNT20') {
      _appliedPromo = code.trim().toUpperCase();
      _discountPercent = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromo = null;
    _discountPercent = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedPromo = null;
    _discountPercent = 0.0;
    notifyListeners();
  }
}
