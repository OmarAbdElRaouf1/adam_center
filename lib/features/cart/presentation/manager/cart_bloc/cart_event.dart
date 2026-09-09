part of 'cart_bloc.dart';

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

// Adds one unit of the product — works whether it's already in the cart
// (increments) or not (adds it as a new item), since both are the same
// "add one unit" call to the server.
class IncrementItem extends CartEvent {
  final int productId;
  final String barCode;

  const IncrementItem(this.productId, this.barCode);

  @override
  List<Object?> get props => [productId, barCode];
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
