import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_one_test/features/checkout/data/datasource/place_order_datasource.dart';
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
    this.isPlacingOrder = false,
    this.orderPlaced = false,
    this.orderError,
  });

  final double subtotal;
  final double deliveryFee;
  final DeliveryInfoModel deliveryInfo;
  final PaymentMethod selectedMethod;
  final double discountRate;
  final int discountAttempt;
  final bool discountCodeValid;
  final bool isPlacingOrder;
  final bool orderPlaced;
  final String? orderError;

  double get discountValue => subtotal * discountRate;
  double get total => subtotal + deliveryFee - discountValue;

  PaymentState copyWith({
    PaymentMethod? selectedMethod,
    double? discountRate,
    int? discountAttempt,
    bool? discountCodeValid,
    bool? isPlacingOrder,
    bool? orderPlaced,
    String? orderError,
  }) {
    return PaymentState(
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      deliveryInfo: deliveryInfo,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      discountRate: discountRate ?? this.discountRate,
      discountAttempt: discountAttempt ?? this.discountAttempt,
      discountCodeValid: discountCodeValid ?? this.discountCodeValid,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      orderPlaced: orderPlaced ?? this.orderPlaced,
      orderError: orderError,
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
    isPlacingOrder,
    orderPlaced,
    orderError,
  ];
}

class PaymentCubit extends Cubit<PaymentState> {
  static const double _deliveryFee = 25;

  final PlaceOrderDatasource _placeOrderDatasource;

  PaymentCubit(
    this._placeOrderDatasource, {
    required double subtotal,
    required DeliveryInfoModel deliveryInfo,
  }) : super(
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

  Future<void> placeOrder() async {
    emit(state.copyWith(isPlacingOrder: true));
    final result = await _placeOrderDatasource.placeOrder(
      deliveryInfo: state.deliveryInfo,
      paymentMethod: state.selectedMethod,
      subtotal: state.subtotal,
      discount: state.discountValue,
      total: state.total,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(isPlacingOrder: false, orderError: failure.message),
      ),
      (_) => emit(state.copyWith(isPlacingOrder: false, orderPlaced: true)),
    );
  }
}
