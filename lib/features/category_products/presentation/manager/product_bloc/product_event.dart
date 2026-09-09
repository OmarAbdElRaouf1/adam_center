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

class GetSearchResultsEvent extends ProductEvent {
  const GetSearchResultsEvent(this.searchKey, {this.categoryIds = const []});

  final String searchKey;
  // Any already-loaded parent categories whose title matched the search
  // key too — their products get merged in alongside the direct
  // product-name search, so searching a category name (e.g. "مشروبات")
  // surfaces its products even though SearchProducts only matches product
  // names server-side.
  final List<int> categoryIds;

  @override
  List<Object> get props => [searchKey, categoryIds];
}
