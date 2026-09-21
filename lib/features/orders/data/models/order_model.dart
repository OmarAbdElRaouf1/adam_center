import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum OrderStatus {
  received,
  cancelled,
  preparing,
  onTheWay;

  String get label {
    switch (this) {
      case OrderStatus.received:
        return 'Order Received';
      case OrderStatus.cancelled:
        return 'Order Cancelled';
      case OrderStatus.preparing:
        return 'Preparing Order';
      case OrderStatus.onTheWay:
        return 'On The Way';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.received:
        return const Color(0xFF2E9E4F);
      case OrderStatus.cancelled:
        return const Color(0xFFE53935);
      case OrderStatus.preparing:
        return const Color(0xFFE9A400);
      case OrderStatus.onTheWay:
        return const Color(0xFF2F80ED);
    }
  }
}

class OrderItemModel extends Equatable {
  const OrderItemModel({
    required this.arName,
    required this.enName,
    required this.quantity,
  });

  final String arName;
  final String enName;
  final num quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      arName: (json['ProductArName'] ?? '').toString(),
      enName: (json['ProductEnName'] ?? '').toString(),
      quantity: (json['Quantity'] as num?) ?? 0,
    );
  }

  @override
  List<Object?> get props => [arName, enName, quantity];
}

class OrderModel extends Equatable {
  const OrderModel({
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.address,
    required this.totalPrice,
    required this.isPrevious,
    this.items = const [],
  });

  final String orderNumber;
  final String date;
  final OrderStatus status;
  // The backend already returns a ready-made, formatted address string
  // (OrderAddress) rather than reliably-populated individual fields (its
  // District/Street/House/Floor/Apartment fields come back null even when
  // OrderAddress itself has the full text) — so this is shown as-is instead
  // of being split back into parts.
  final String address;
  final double totalPrice;
  final bool isPrevious;
  // Not part of the orders list response — filled in from a per-order call to
  // GetOrderProductsByCustomerID (which is keyed by OrderNo, not CustomerID).
  final List<OrderItemModel> items;

  OrderModel copyWith({List<OrderItemModel>? items}) {
    return OrderModel(
      orderNumber: orderNumber,
      date: date,
      status: status,
      address: address,
      totalPrice: totalPrice,
      isPrevious: isPrevious,
      items: items ?? this.items,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderNumber: (json['OrderNo'] ?? '').toString(),
      date: (json['OrderDate'] ?? '').toString().split('T').first,
      status: _statusFromJson(json),
      address: json['OrderAddress'] ?? '',
      totalPrice: (json['FinalValue'] as num?)?.toDouble() ?? 0,
      // No "current vs previous" flag exists on the backend — a delivered
      // order is treated as previous, anything still in progress as current.
      isPrevious: json['Delivered'] == true,
    );
  }

  static OrderStatus _statusFromJson(Map<String, dynamic> json) {
    if (json['Delivered'] == true) return OrderStatus.received;
    if (json['StartDeliver'] == true ||
        json['SendingOrder'] == true ||
        json['UnderDeliver'] == true) {
      return OrderStatus.onTheWay;
    }
    return OrderStatus.preparing;
  }

  @override
  List<Object?> get props => [
    orderNumber,
    date,
    status,
    address,
    totalPrice,
    isPrevious,
    items,
  ];
}
