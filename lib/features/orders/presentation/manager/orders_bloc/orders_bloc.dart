import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/orders/data/datasource/orders_datasource.dart';
import 'package:the_one_test/features/orders/data/models/order_model.dart';

part 'orders_event.dart';

class OrdersBloc extends Bloc<OrdersEvent, BaseState<OrderModel>> {
  final OrdersDatasource _ordersDatasource;

  OrdersBloc(this._ordersDatasource) : super(const BaseState<OrderModel>()) {
    on<FetchOrders>(_onFetchOrders);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<BaseState<OrderModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _ordersDatasource.getOrders();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (orders) => emit(state.copyWith(status: Status.success, items: orders)),
    );
  }
}
