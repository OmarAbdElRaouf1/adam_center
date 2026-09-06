import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class FetchFavorites extends FavoriteEvent {
  const FetchFavorites();
}

class ToggleFavorite extends FavoriteEvent {
  final int productId;
  final bool isCurrentlyFavorite;

  const ToggleFavorite(this.productId, this.isCurrentlyFavorite);

  @override
  List<Object?> get props => [productId, isCurrentlyFavorite];
}
