import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/delete_cart_datasource.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_event.dart';

class CartBloc extends Bloc<CartEvent, BaseState<CartItemModel>> {
  final AddToCartDataSource _cartDataSource;
  final DeleteCartDataSource _deleteCartDataSource;

  CartBloc({
    required this._cartDataSource,
    required DeleteCartDataSource deleteCartDataSource,
  }) : _deleteCartDataSource = deleteCartDataSource,
       super(const BaseState<CartItemModel>()) {
    on<FetchCartItems>(_onFetchCartItems);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<DeleteCartItem>(_onDeleteCartItem);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onFetchCartItems(
    FetchCartItems event,
    Emitter<BaseState<CartItemModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, metadata: {'action': 'fetch'}));

    final result = await _cartDataSource.getCartItems();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'fetch'},
        ),
      ),
      (items) {
        loggerInfo("items for Cart ${items.map((e) => e.toJson())}");
        emit(
          state.copyWith(
            status: Status.success,
            items: items,
            metadata: {'action': 'fetch'},
          ),
        );
      },
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<BaseState<CartItemModel>> emit,
  ) async {
    final currentItems = state.items;
    final index = currentItems.indexWhere(
      (item) => item.productID == event.productId,
    );
    if (index >= 0) {
      final newQuantity = event.newQuantity.clamp(0, 100);
      emit(
        state.copyWith(
          status: Status.loading,
          metadata: {'action': 'update', 'productId': event.productId},
        ),
      );

      if (newQuantity == 0) {
        final result = await _deleteCartDataSource.deleteCartItem(
          event.productId,
          event.barCode,
        );
        result.fold(
          (failure) => emit(
            state.copyWith(
              status: Status.failure,
              failure: failure,
              errorMessage: failure.message,
              metadata: {'action': 'update', 'productId': event.productId},
            ),
          ),
          (_) => emit(
            state.copyWith(
              status: Status.success,
              items: currentItems
                  .where((item) => item.productID != event.productId)
                  .toList(),
              metadata: {'action': 'update', 'productId': event.productId},
            ),
          ),
        );
      } else {
        final updatedItems = List<CartItemModel>.from(currentItems);
        updatedItems[index] = updatedItems[index].copyWith(
          salesQuantity: newQuantity,
        );
        emit(
          state.copyWith(
            status: Status.success,
            items: updatedItems,
            metadata: {'action': 'update', 'productId': event.productId},
          ),
        );
      }
    }
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

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'delete', 'productId': event.productId},
        ),
      ),
      (_) {
        final currentItems = state.items;
        final index = currentItems.indexWhere(
          (item) => item.productID == event.productId,
        );
        if (index >= 0) {
          final currentQuantity = currentItems[index].salesQuantity;
          final newQuantity = (currentQuantity - 1).clamp(0, 100);
          if (newQuantity == 0) {
            emit(
              state.copyWith(
                status: Status.success,
                items: currentItems
                    .where((item) => item.productID != event.productId)
                    .toList(),
                metadata: {'action': 'delete', 'productId': event.productId},
              ),
            );
          } else {
            final updatedItems = List<CartItemModel>.from(currentItems);
            updatedItems[index] = updatedItems[index].copyWith(
              salesQuantity: newQuantity,
            );
            emit(
              state.copyWith(
                status: Status.success,
                items: updatedItems,
                metadata: {'action': 'delete', 'productId': event.productId},
              ),
            );
          }
        }
      },
    );
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

    if (lastFailure == null) {
      emit(
        state.copyWith(
          status: Status.success,
          items: const [],
          metadata: {'action': 'clear'},
        ),
      );
      return;
    }

    // Some units may not have been removed — refetch instead of guessing
    // at the resulting quantities so local state can't drift from the server.
    final refetch = await _cartDataSource.getCartItems();
    refetch.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'clear'},
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: Status.failure,
          failure: lastFailure,
          errorMessage: lastFailure?.message,
          items: items,
          metadata: {'action': 'clear'},
        ),
      ),
    );
  }
}
