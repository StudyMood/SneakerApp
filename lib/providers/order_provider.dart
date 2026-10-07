// ============================================================================
// [START] FILE: order_provider.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/notification_item.dart';
import '../data/mock_data.dart';
import '../services/firebase_service.dart';
import 'notification_provider.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] ORDER PROVIDER
// ============================================================================
class OrderProvider extends ChangeNotifier {
  final List<OrderItem> _orders = List.from(MockData.initialOrders);
  StreamSubscription<List<OrderItem>>? _ordersSubscription;

  OrderProvider() {
    _initCloudOrdersSync();
  }

  void _initCloudOrdersSync() {
    _ordersSubscription = FirebaseService.instance.getOrdersStream().listen(
      (cloudOrders) {
        if (cloudOrders.isNotEmpty) {
          _orders
            ..clear()
            ..addAll(cloudOrders);
          notifyListeners();
        }
      },
      onError: (e) {
        // Safe fallback to local list if offline
      },
    );
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }

  List<OrderItem> get orders => List.unmodifiable(_orders);

  OrderItem? get latestOrder => _orders.isNotEmpty ? _orders.first : null;

  double get totalRevenue => _orders.fold(0.0, (sum, o) => sum + o.total);

  int get totalOrdersCount => _orders.length;

  int get activeOrdersCount =>
      _orders.where((o) => o.status != OrderStatus.delivered).length;

  int get deliveredOrdersCount =>
      _orders.where((o) => o.status == OrderStatus.delivered).length;

  OrderItem placeOrder({
    required List<CartItem> items,
    required double total,
    required String address,
    required String paymentMethod,
  }) {
    final newOrder = OrderItem(
      id: '#${(12346 + _orders.length)}',
      items: List.from(items),
      total: total,
      date: 'Today',
      status: OrderStatus.processing,
      address: address,
      paymentMethod: paymentMethod,
    );
    _orders.insert(0, newOrder);
    notifyListeners();
    // Sync order to Firebase Firestore (Non-blocking)
    FirebaseService.instance.saveOrderToCloud(newOrder);

    NotificationProvider.send(
      title: 'Order Confirmed! 📦',
      message: 'Order ${newOrder.id} placed successfully for ₹${newOrder.total.toStringAsFixed(0)}. Track it in Orders.',
      type: NotificationType.orderPlaced,
    );

    return newOrder;
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
      // Sync status change to Firebase Firestore (Non-blocking)
      FirebaseService.instance.updateOrderStatusInCloud(orderId, newStatus);

      NotificationProvider.send(
        title: newStatus == OrderStatus.delivered
            ? 'Order Delivered! 🎉'
            : (newStatus == OrderStatus.shipped
                ? 'Order Shipped! 🚚'
                : 'Order Processing ⏳'),
        message: 'Order $orderId status has been updated to ${newStatus.name.toUpperCase()}.',
        type: newStatus == OrderStatus.delivered
            ? NotificationType.orderDelivered
            : NotificationType.orderShipped,
      );
    }
  }

  void deleteOrder(String orderId) {
    _orders.removeWhere((o) => o.id == orderId);
    notifyListeners();
  }
}
// ============================================================================
// [END] ORDER PROVIDER
// ============================================================================

// ============================================================================
// [END] FILE: order_provider.dart
// ============================================================================
