import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/category_products/data/datasource/product_datasource.dart';

part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, BaseState<ItemModel>> {
  final ProductDatasource productDatasource;

  ProductBloc(this.productDatasource) : super(BaseState<ItemModel>()) {
    on<GetProductsByCategoryEvent>(
      (event, emit) =>
          _fetch(emit, productDatasource.getProductsByCategory(categoryId: event.categoryId)),
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
}
