part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ApplyDiscountCode extends PaymentEvent {
  final String code;

  const ApplyDiscountCode(this.code);

  @override
  List<Object?> get props => [code];
}

class PlaceOrder extends PaymentEvent {
  final DeliveryInfoModel deliveryInfo;

  const PlaceOrder(this.deliveryInfo);

  @override
  List<Object?> get props => [deliveryInfo];
}
