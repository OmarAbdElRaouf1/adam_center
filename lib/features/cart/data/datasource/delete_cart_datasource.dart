import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';

abstract interface class DeleteCartDataSource {
  Future<Either<Failure, void>> deleteCartItem(int productId, String barCode);
}

class DeleteCartDataSourceImpl implements DeleteCartDataSource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;

  DeleteCartDataSourceImpl(
    this._genericDataSource,
    this._userSessionDatasource,
  );

  @override
  Future<Either<Failure, void>> deleteCartItem(
    int productId,
    String barCode,
  ) async {
    final customerId = _userSessionDatasource.getUser()?.customerId;
    final queryParameters = {
      'CustomerID': customerId.toString(),
      'ProductID': productId.toString(),
      "BarCode": barCode,
    };

    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.deleteOneItemFromBasket,
      queryParameters: queryParameters,
    );
    return result.fold((failure) => Left(failure), (_) => const Right(null));
  }
}
