import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class FetchCartItems extends CartEvent {
  const FetchCartItems();

  @override
  List<Object?> get props => [];
}

class UpdateQuantity extends CartEvent {
  final int productId;
  final int newQuantity;
  final String barCode;

  const UpdateQuantity(this.productId, this.newQuantity, this.barCode);

  @override
  List<Object?> get props => [productId, newQuantity, barCode];
}

class DeleteCartItem extends CartEvent {
  final int productId;
  final String barCode;

  const DeleteCartItem(this.productId, this.barCode);

  @override
  List<Object?> get props => [productId, barCode];
}

class ClearCart extends CartEvent {
  const ClearCart();

  @override
  List<Object?> get props => [];
}
