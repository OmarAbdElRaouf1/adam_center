part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class SelectPaymentMethod extends PaymentEvent {
  final PaymentMethod method;

  const SelectPaymentMethod(this.method);

  @override
  List<Object?> get props => [method];
}

class ApplyDiscountCode extends PaymentEvent {
  final String code;

  const ApplyDiscountCode(this.code);

  @override
  List<Object?> get props => [code];
}

class PlaceOrder extends PaymentEvent {
  const PlaceOrder();
}
