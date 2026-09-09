import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';

abstract interface class AddToCartDataSource {
  Future<Either<Failure, void>> addToCart(AddToCartRequest request);

  Future<Either<Failure, List<CartItemModel>>> getCartItems();
}

// feature/main/details/data_source/add_to_Cart_data_source.dart
class AddToCartDataSourceImpl implements AddToCartDataSource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;

  AddToCartDataSourceImpl(this._genericDataSource, this._userSessionDatasource);

  @override
  Future<Either<Failure, void>> addToCart(AddToCartRequest request) async {
    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.addToBasket,
      data: request.toJson(),
    );
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItems() {
    final user = _userSessionDatasource.getUser();
    return _genericDataSource.fetchData<CartItemModel>(
      endpoint: EndPoints.getCustomerBasket,
      queryParameters: UserModel.identityParams(user),
      fromJson: CartItemModel.fromJson,
    );
  }
}
