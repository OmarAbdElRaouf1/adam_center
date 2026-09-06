import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/params/pagination_params.dart';

abstract class ProductDatasource {
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
}

class ProductDatasourceImpl implements ProductDatasource {
  final GenericDataSource genericDataSource;
  final UserSessionCache userSessionDatasource;
  ProductDatasourceImpl(this.genericDataSource, this.userSessionDatasource);

  Future<Either<Failure, List<ItemModel>>> _fetchProducts(
    String endpoint, {
    required int page,
    required int pageSize,
    Map<String, dynamic>? extraParams,
  }) {
    final user = userSessionDatasource.getUser();
    return genericDataSource.fetchData<ItemModel>(
      endpoint: endpoint,
      paginationParams: PaginationParams(page: page, limit: pageSize),
      queryParameters: {
        ...?extraParams,
        if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
        if (user != null) 'CustomerPhone': user.customerPhone,
      },
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
}
