import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';

abstract class AddToCartEvent {}

class AddToCart extends AddToCartEvent {
  final AddToCartRequest request;

  AddToCart(this.request);
}
