// ============================================================================
// [START] FILE: order.dart
// ============================================================================
import 'cart_item.dart';

enum OrderStatus {
  delivered,
  shipped,
  processing,
}

class OrderItem {
  final String id;
  final List<CartItem> items;
  final double total;
  final String date;
  final OrderStatus status;
  final String address;
  final String paymentMethod;

  OrderItem({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
    required this.address,
    required this.paymentMethod,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.processing:
        return 'Processing';
    }
  }

  OrderItem copyWith({
    String? id,
    List<CartItem>? items,
    double? total,
    String? date,
    OrderStatus? status,
    String? address,
    String? paymentMethod,
  }) {
    return OrderItem(
      id: id ?? this.id,
      items: items ?? this.items,
      total: total ?? this.total,
      date: date ?? this.date,
      status: status ?? this.status,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'date': date,
      'status': status.name,
      'address': address,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map, [String? docId]) {
    OrderStatus parsedStatus;
    final statusStr = map['status'] as String? ?? 'processing';
    if (statusStr == 'delivered') {
      parsedStatus = OrderStatus.delivered;
    } else if (statusStr == 'shipped') {
      parsedStatus = OrderStatus.shipped;
    } else {
      parsedStatus = OrderStatus.processing;
    }

    final rawItems = map['items'] as List? ?? [];
    final itemsList = rawItems
        .map((item) => CartItem.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();

    return OrderItem(
      id: docId ?? (map['id'] as String? ?? ''),
      items: itemsList,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] as String? ?? 'Today',
      status: parsedStatus,
      address: map['address'] as String? ?? '',
      paymentMethod: map['paymentMethod'] as String? ?? 'Cash on Delivery',
    );
  }
}
// ============================================================================
// [END] FILE: order.dart
// ============================================================================
