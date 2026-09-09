import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/favorites/data/datasource/favorite_datasource.dart';

part 'favorite_event.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, BaseState<ItemModel>> {
  final FavoriteDatasource _favoriteDatasource;

  FavoriteBloc(this._favoriteDatasource) : super(const BaseState<ItemModel>()) {
    on<FetchFavorites>(_onFetchFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetchFavorites(
    FetchFavorites event,
    Emitter<BaseState<ItemModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, metadata: {'action': 'fetch'}));

    final result = await _favoriteDatasource.getFavorites();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'fetch'},
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: Status.success,
          items: items,
          metadata: {'action': 'fetch'},
        ),
      ),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<BaseState<ItemModel>> emit,
  ) async {
    emit(
      state.copyWith(
        status: Status.loading,
        metadata: {'action': 'toggle', 'productId': event.productId},
      ),
    );

    final result = event.isCurrentlyFavorite
        ? await _favoriteDatasource.removeFavorite(event.productId)
        : await _favoriteDatasource.addFavorite(event.productId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
          metadata: {'action': 'toggle', 'productId': event.productId},
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: Status.success,
          // If this was an unfavorite, drop it from the favorites list too
          // (so the Favorites tab reflects it immediately); otherwise leave
          // the list untouched — it's irrelevant on screens other than the
          // Favorites tab.
          items: event.isCurrentlyFavorite
              ? state.items
                    .where((item) => item.productId != event.productId)
                    .toList()
              : state.items,
          metadata: {'action': 'toggle', 'productId': event.productId},
        ),
      ),
    );
  }
}
