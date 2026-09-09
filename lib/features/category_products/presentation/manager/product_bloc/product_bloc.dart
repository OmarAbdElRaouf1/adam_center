import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/category_products/data/datasource/product_datasource.dart';

part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, BaseState<ItemModel>> {
  final ProductDatasource productDatasource;

  // Bumped on every search dispatch so a slower, older search response
  // (events are processed concurrently, not queued) can't land after a
  // newer one and re-trigger another full grid rebuild.
  int _searchRequestId = 0;

  ProductBloc(this.productDatasource) : super(BaseState<ItemModel>()) {
    on<GetProductsByCategoryEvent>(
      (event, emit) => _fetch(
        emit,
        productDatasource.getProductsByCategory(categoryId: event.categoryId),
      ),
    );
    on<GetNewProductsEvent>(
      (event, emit) => _fetch(emit, productDatasource.getNewProducts()),
    );
    on<GetBestSellersEvent>(
      (event, emit) => _fetch(emit, productDatasource.getBestSellers()),
    );
    on<GetBiggestDiscountProductsEvent>(
      (event, emit) =>
          _fetch(emit, productDatasource.getBiggestDiscountProducts()),
    );
    on<GetSearchResultsEvent>(_onSearch);
  }

  Future<void> _fetch(
    Emitter<BaseState<ItemModel>> emit,
    Future<Either<Failure, List<ItemModel>>> request,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await request;

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (products) {
        emit(state.copyWith(status: Status.success, items: products));
      },
    );
  }

  // Merges direct product-name search results with a barcode-match search
  // and the products of any already-matched categories, so a search covers
  // what a product is named, its barcode, and what category it's in.
  Future<void> _onSearch(
    GetSearchResultsEvent event,
    Emitter<BaseState<ItemModel>> emit,
  ) async {
    final requestId = ++_searchRequestId;
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final results = await Future.wait([
      productDatasource.searchProducts(searchKey: event.searchKey),
      productDatasource.searchProductsByBarcode(event.searchKey),
      ...event.categoryIds.map(
        (id) => productDatasource.getProductsByCategory(categoryId: id),
      ),
    ]);

    // A newer search already superseded this one — drop this response
    // instead of emitting and re-triggering another grid rebuild.
    if (requestId != _searchRequestId) return;

    final merged = <int, ItemModel>{};
    Failure? lastFailure;
    var anySuccess = false;

    for (final result in results) {
      result.fold((failure) => lastFailure = failure, (items) {
        anySuccess = true;
        for (final item in items) {
          merged[item.productId] = item;
        }
      });
    }

    if (!anySuccess && lastFailure != null) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: lastFailure!.message,
        ),
      );
      return;
    }

    emit(state.copyWith(status: Status.success, items: merged.values.toList()));
  }
}
