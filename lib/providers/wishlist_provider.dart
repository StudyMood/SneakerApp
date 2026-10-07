import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../models/sneaker.dart';
import '../data/mock_data.dart';
import 'notification_provider.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Sneaker> _items = [
    // Pre-populate with Screen 14 items
    MockData.sneakers[2], // Nike Dunk Low
    MockData.sneakers[0], // Air Jordan 1
    MockData.sneakers[3], // Nike Blazer
  ];

  List<Sneaker> get items => List.unmodifiable(_items);

  bool isFavorite(String sneakerId) {
    return _items.any((item) => item.id == sneakerId);
  }

  void toggleWishlist(Sneaker sneaker) {
    final index = _items.indexWhere((item) => item.id == sneaker.id);
    if (index != -1) {
      _items.removeAt(index);
    } else {
      _items.add(sneaker);
      NotificationProvider.send(
        title: 'Saved to Wishlist ❤️',
        message: '${sneaker.name} added to your wishlist.',
        type: NotificationType.specialOffer,
      );
    }
    notifyListeners();
  }

  void removeFromWishlist(String sneakerId) {
    _items.removeWhere((item) => item.id == sneakerId);
    notifyListeners();
  }
}
