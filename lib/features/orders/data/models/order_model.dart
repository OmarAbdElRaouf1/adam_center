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

class OrderAddress {
  const OrderAddress({
    required this.area,
    required this.block,
    required this.street,
    required this.avenue,
    required this.house,
    required this.floor,
    required this.apartment,
  });

  final String area;
  final String block;
  final String street;
  final String avenue;
  final String house;
  final String floor;
  final String apartment;
}

class OrderModel {
  const OrderModel({
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.address,
    required this.totalPrice,
    required this.isPrevious,
  });

  final String orderNumber;
  final String date;
  final OrderStatus status;
  final OrderAddress address;
  final double totalPrice;
  final bool isPrevious;
}
