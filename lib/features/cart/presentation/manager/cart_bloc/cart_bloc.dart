import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/delete_cart_datasource.dart';
import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';

part 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, BaseState<CartItemModel>> {
  final AddToCartDataSource _cartDataSource;
  final DeleteCartDataSource _deleteCartDataSource;
  final UserSessionCache _userSessionCache;

  CartBloc({
    required this._cartDataSource,
    required this._deleteCartDataSource,
    required this._userSessionCache,
  }) : super(const BaseState<CartItemModel>()) {
    on<FetchCartItems>(_onFetchCartItems);
    on<IncrementItem>(_onIncrementItem);
    on<DeleteCartItem>(_onDeleteCartItem);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onFetchCartItems(
    FetchCartItems event,
    Emitter<BaseState<CartItemModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, metadata: {'action': 'fetch'}));
    await _refetch(emit, action: 'fetch');
  }

  // Cart items are never reconstructed client-side — every mutation below
  // calls the real add/delete endpoint and then re-fetches the basket from
  // the server, so what's shown always matches what the server actually has.
  Future<void> _refetch(
    Emitter<BaseState<CartItemModel>> emit, {
    required String action,
    Failure? carryFailure,
  }) async {
    final result = await _cartDataSource.getCartItems();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: carryFailure ?? failure,
          errorMessage: (carryFailure ?? failure).message,
          metadata: {'action': action},
        ),
      ),
      (items) {
        loggerInfo("items for Cart ${items.map((e) => e.toJson())}");
        emit(
          state.copyWith(
            status: carryFailure == null ? Status.success : Status.failure,
            failure: carryFailure,
            errorMessage: carryFailure?.message,
            items: items,
            metadata: {'action': action},
          ),
        );
      },
    );
  }

  Future<void> _onIncrementItem(
    IncrementItem event,
    Emitter<BaseState<CartItemModel>> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        metadata: {'action': 'increment', 'productId': event.productId},
      ),
    );

    final result = await _cartDataSource.addToCart(
      AddToCartRequest(
        customerID: _userSessionCache.getUser()?.customerId ?? 0,
        productID: event.productId,
        productBarcode: event.barCode,
      ),
    );

    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'increment', 'productId': event.productId},
        ),
      );
      return;
    }

    await _refetch(emit, action: 'increment');
  }

  Future<void> _onDeleteCartItem(
    DeleteCartItem event,
    Emitter<BaseState<CartItemModel>> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        metadata: {'action': 'delete', 'productId': event.productId},
      ),
    );

    final result = await _deleteCartDataSource.deleteCartItem(
      event.productId,
      event.barCode,
    );

    final failure = result.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'delete', 'productId': event.productId},
        ),
      );
      return;
    }

    await _refetch(emit, action: 'delete');
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<BaseState<CartItemModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, metadata: {'action': 'clear'}));
    Failure? lastFailure;

    for (final item in state.items) {
      for (var unit = 0; unit < item.salesQuantity; unit++) {
        final result = await _deleteCartDataSource.deleteCartItem(
          item.productID,
          item.barCode,
        );
        final failure = result.fold((f) => f, (_) => null);
        if (failure != null) {
          lastFailure = failure;
          break; // stop this item's remaining units, move to the next item
        }
      }
    }

    await _refetch(emit, action: 'clear', carryFailure: lastFailure);
  }
}
