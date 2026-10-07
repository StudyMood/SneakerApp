import 'package:flutter/material.dart';

enum NotificationType {
  orderPlaced,
  orderShipped,
  orderDelivered,
  newArrivals,
  priceDrop,
  specialOffer,
  cartUpdated,
  general,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final NotificationType type;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}
