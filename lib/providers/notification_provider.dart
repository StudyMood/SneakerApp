// ============================================================================
// [START] FILE: notification_provider.dart
// ============================================================================
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  static NotificationProvider? _instance;
  static NotificationProvider? get instance => _instance;

  static void send({
    required String title,
    required String message,
    required NotificationType type,
    IconData? icon,
    Color? iconColor,
    bool showInAppBanner = true,
    VoidCallback? onTap,
  }) {
    _instance?.notify(
      title: title,
      message: message,
      type: type,
      icon: icon,
      iconColor: iconColor,
      showInAppBanner: showInAppBanner,
      onTap: onTap,
    );
  }

  final List<NotificationItem> _notifications =
      List.from(MockData.initialNotifications);

  NotificationProvider() {
    _instance = this;
  }

  List<NotificationItem> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void notify({
    required String title,
    required String message,
    required NotificationType type,
    IconData? icon,
    Color? iconColor,
    bool showInAppBanner = true,
    VoidCallback? onTap,
  }) {
    final defaultIcon = _getDefaultIcon(type);
    final defaultColor = _getDefaultColor(type);

    final item = NotificationItem(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      timeAgo: 'Just now',
      type: type,
      icon: icon ?? defaultIcon,
      iconColor: iconColor ?? defaultColor,
      isRead: false,
    );

    _notifications.insert(0, item);
    notifyListeners();

    if (showInAppBanner) {
      NotificationService.showInAppBanner(
        title: title,
        message: message,
        icon: icon ?? defaultIcon,
        iconColor: iconColor ?? defaultColor,
        onTap: onTap,
      );
    }
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  IconData _getDefaultIcon(NotificationType type) {
    switch (type) {
      case NotificationType.orderPlaced:
        return Icons.shopping_bag_rounded;
      case NotificationType.orderShipped:
        return Icons.local_shipping_rounded;
      case NotificationType.orderDelivered:
        return Icons.check_circle_rounded;
      case NotificationType.newArrivals:
        return Icons.local_fire_department_rounded;
      case NotificationType.priceDrop:
        return Icons.sell_rounded;
      case NotificationType.specialOffer:
        return Icons.discount_rounded;
      case NotificationType.cartUpdated:
        return Icons.shopping_cart_rounded;
      case NotificationType.general:
        return Icons.notifications_rounded;
    }
  }

  Color _getDefaultColor(NotificationType type) {
    switch (type) {
      case NotificationType.orderPlaced:
        return const Color(0xFF2874F0);
      case NotificationType.orderShipped:
        return const Color(0xFF007AFF);
      case NotificationType.orderDelivered:
        return const Color(0xFF28A745);
      case NotificationType.newArrivals:
        return const Color(0xFFFF5722);
      case NotificationType.priceDrop:
        return const Color(0xFFFF9800);
      case NotificationType.specialOffer:
        return const Color(0xFFE91E63);
      case NotificationType.cartUpdated:
        return const Color(0xFF2874F0);
      case NotificationType.general:
        return const Color(0xFF9C27B0);
    }
  }
}
// ============================================================================
// [END] FILE: notification_provider.dart
// ============================================================================
