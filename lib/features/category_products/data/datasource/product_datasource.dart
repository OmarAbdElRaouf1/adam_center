import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/params/pagination_params.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

abstract interface class ProductDatasource {
  Future<Either<Failure, List<ItemModel>>> getProductsByCategory({
    required int categoryId,
    int page = 1,
    int pageSize = 50,
  });

  Future<Either<Failure, List<ItemModel>>> getNewProducts({
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<ItemModel>>> getBestSellers({
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<ItemModel>>> getBiggestDiscountProducts({
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<ItemModel>>> searchProducts({
    required String searchKey,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<ItemModel>>> searchProductsByBarcode(
    String barcode,
  );
}

class ProductDatasourceImpl implements ProductDatasource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;
  ProductDatasourceImpl(this._genericDataSource, this._userSessionDatasource);

  Future<Either<Failure, List<ItemModel>>> _fetchProducts(
    String endpoint, {
    required int page,
    required int pageSize,
    Map<String, dynamic>? extraParams,
  }) {
    final user = _userSessionDatasource.getUser();
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: endpoint,
      paginationParams: PaginationParams(page: page, limit: pageSize),
      queryParameters: {...?extraParams, ...UserModel.identityParams(user)},
      fromJson: ItemModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<ItemModel>>> getProductsByCategory({
    required int categoryId,
    int page = 1,
    int pageSize = 50,
  }) => _fetchProducts(
    EndPoints.subCategoryProducts,
    page: page,
    pageSize: pageSize,
    extraParams: {'categoryId': categoryId},
  );

  @override
  Future<Either<Failure, List<ItemModel>>> getNewProducts({
    int page = 1,
    int pageSize = 20,
  }) => _fetchProducts(EndPoints.newProduct, page: page, pageSize: pageSize);

  @override
  Future<Either<Failure, List<ItemModel>>> getBestSellers({
    int page = 1,
    int pageSize = 20,
  }) => _fetchProducts(EndPoints.bestSeller, page: page, pageSize: pageSize);

  @override
  Future<Either<Failure, List<ItemModel>>> getBiggestDiscountProducts({
    int page = 1,
    int pageSize = 20,
  }) =>
      _fetchProducts(EndPoints.biggestDiscount, page: page, pageSize: pageSize);

  @override
  Future<Either<Failure, List<ItemModel>>> searchProducts({
    required String searchKey,
    int page = 1,
    int pageSize = 20,
  }) => _fetchProducts(
    EndPoints.searchProducts,
    page: page,
    pageSize: pageSize,
    extraParams: {'searchKey': searchKey},
  );

  // Product/SearchProductByBarcode — confirmed against this backend's live
  // Help page. Its only documented parameter is Barcode (no pagination), so
  // this doesn't go through _fetchProducts's PaginationParams.
  @override
  Future<Either<Failure, List<ItemModel>>> searchProductsByBarcode(
    String barcode,
  ) {
    final user = _userSessionDatasource.getUser();
    return _genericDataSource.fetchData<ItemModel>(
      endpoint: EndPoints.searchProductByBarcode,
      queryParameters: {
        'Barcode': barcode,
        ...UserModel.identityParams(user),
      },
      fromJson: ItemModel.fromJson,
    );
  }
}
