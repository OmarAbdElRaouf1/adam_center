import 'package:equatable/equatable.dart';

class AddToCartRequest extends Equatable {
  final int customerID;
  final int productID;
  final String productBarcode;

  const AddToCartRequest({
    required this.customerID,
    required this.productID,
    required this.productBarcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'CustomerID': customerID,
      'ProductID': productID,
      "BarCode": productBarcode,
    };
  }

  @override
  List<Object?> get props => [customerID, productID, productBarcode];
}

class AddToCartResponse extends Equatable {
  final bool success;
  final String? message;

  const AddToCartResponse({required this.success, this.message});

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [success, message];
}
