import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_events.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, BaseState<void>> {
  final AddToCartDataSource _addToCartDataSource;

  AddToCartBloc({required this._addToCartDataSource})
    : super(const BaseState<void>()) {
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<BaseState<void>> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        metadata: {'action': 'add', 'productId': event.request.productID},
      ),
    );

    final result = await _addToCartDataSource.addToCart(event.request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'add', 'productId': event.request.productID},
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          metadata: {'action': 'add', 'productId': event.request.productID},
        ),
      ),
    );
  }
}
