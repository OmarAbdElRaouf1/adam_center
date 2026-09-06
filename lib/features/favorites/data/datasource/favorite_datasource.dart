import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/favorites/data/datasource/local_favorites_store.dart';

abstract interface class FavoriteDatasource {
  Future<Either<Failure, List<ItemModel>>> getFavorites();

  Future<Either<Failure, void>> addFavorite(int productId);

  Future<Either<Failure, void>> removeFavorite(int productId);
}

class FavoriteDatasourceImpl implements FavoriteDatasource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;
  final LocalFavoritesStore _localFavoritesStore;

  FavoriteDatasourceImpl(
    this._genericDataSource,
    this._userSessionDatasource,
    this._localFavoritesStore,
  );

  @override
  Future<Either<Failure, List<ItemModel>>> getFavorites() async {
    // The backend has no working "list my favorite products" endpoint (see
    // LocalFavoritesStore) — build the list from the locally-tracked IDs by
    // looking each one up individually instead.
    final ids = _localFavoritesStore.getIds();
    if (ids.isEmpty) return const Right([]);

    final user = _userSessionDatasource.getUser();
    final items = <ItemModel>[];
    for (final id in ids) {
      final result = await _genericDataSource.fetchData<ItemModel>(
        endpoint: EndPoints.productDetails,
        queryParameters: {
          'ProductId': id,
          if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
          if (user != null) 'CustomerPhone': user.customerPhone,
        },
        fromJson: ItemModel.fromJson,
      );
      result.fold((_) {}, (products) {
        if (products.isNotEmpty) items.add(products.first);
      });
    }
    return Right(items);
  }

  @override
  Future<Either<Failure, void>> addFavorite(int productId) async {
    final user = _userSessionDatasource.getUser();
    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.addFavorite,
      data: {
        if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
        'ProductID': productId,
      },
    );
    if (result.isSuccess) {
      await _localFavoritesStore.add(productId);
    }
    return result;
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int productId) async {
    final user = _userSessionDatasource.getUser();
    // The registered backend route is DeleteCustomerProductBYID (confirmed via
    // the API's help page) — EndPoints.deleteFavorite points at the wrong,
    // unregistered action name "DeleteCustomerProduct", which 404s.
    final result = await _genericDataSource.deleteData<void>(
      endpoint: 'Customer/DeleteCustomerProductBYID',
      queryParameters: {
        if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
        'ProductID': productId,
      },
    );
    if (result.isSuccess) {
      await _localFavoritesStore.remove(productId);
    }
    return result;
  }
}
