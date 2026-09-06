part of 'product_bloc.dart';

class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductsByCategoryEvent extends ProductEvent {
  const GetProductsByCategoryEvent(this.categoryId);

  final int categoryId;

  @override
  List<Object> get props => [categoryId];
}

class GetNewProductsEvent extends ProductEvent {
  const GetNewProductsEvent();
}

class GetBestSellersEvent extends ProductEvent {
  const GetBestSellersEvent();
}

class GetBiggestDiscountProductsEvent extends ProductEvent {
  const GetBiggestDiscountProductsEvent();
}
