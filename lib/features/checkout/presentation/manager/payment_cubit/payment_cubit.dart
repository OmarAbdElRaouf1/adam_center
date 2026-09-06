import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_one_test/features/checkout/data/models/delivery_info_model.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/payment_methods_section.dart';

class PaymentState extends Equatable {
  const PaymentState({
    required this.subtotal,
    required this.deliveryFee,
    required this.deliveryInfo,
    this.selectedMethod = PaymentMethod.card,
    this.discountRate = 0,
    this.discountAttempt = 0,
    this.discountCodeValid = true,
    this.orderPlaced = false,
  });

  final double subtotal;
  final double deliveryFee;
  final DeliveryInfoModel deliveryInfo;
  final PaymentMethod selectedMethod;
  final double discountRate;
  final int discountAttempt;
  final bool discountCodeValid;
  final bool orderPlaced;

  double get discountValue => subtotal * discountRate;
  double get total => subtotal + deliveryFee - discountValue;

  PaymentState copyWith({
    PaymentMethod? selectedMethod,
    double? discountRate,
    int? discountAttempt,
    bool? discountCodeValid,
    bool? orderPlaced,
  }) {
    return PaymentState(
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      deliveryInfo: deliveryInfo,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      discountRate: discountRate ?? this.discountRate,
      discountAttempt: discountAttempt ?? this.discountAttempt,
      discountCodeValid: discountCodeValid ?? this.discountCodeValid,
      orderPlaced: orderPlaced ?? this.orderPlaced,
    );
  }

  @override
  List<Object?> get props => [
    subtotal,
    deliveryFee,
    deliveryInfo,
    selectedMethod,
    discountRate,
    discountAttempt,
    discountCodeValid,
    orderPlaced,
  ];
}

class PaymentCubit extends Cubit<PaymentState> {
  static const double _deliveryFee = 25;

  PaymentCubit({required double subtotal, required DeliveryInfoModel deliveryInfo})
    : super(
        PaymentState(
          subtotal: subtotal,
          deliveryFee: _deliveryFee,
          deliveryInfo: deliveryInfo,
        ),
      );

  void selectMethod(PaymentMethod method) =>
      emit(state.copyWith(selectedMethod: method));

  void applyDiscountCode(String code) {
    if (code.trim().isEmpty) {
      emit(
        state.copyWith(
          discountCodeValid: false,
          discountAttempt: state.discountAttempt + 1,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        discountRate: 0.10,
        discountCodeValid: true,
        discountAttempt: state.discountAttempt + 1,
      ),
    );
  }

  void placeOrder() => emit(state.copyWith(orderPlaced: true));
}
