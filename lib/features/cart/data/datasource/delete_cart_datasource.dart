import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/services/service_locator/service_locator.dart';

abstract interface class DeleteCartDataSource {
  Future<Either<Failure, void>> deleteCartItem(int productId, String barCode);
}

class DeleteCartDataSourceImpl implements DeleteCartDataSource {
  final GenericDataSource _genericDataSource;

  DeleteCartDataSourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, void>> deleteCartItem(
    int productId,
    String barCode,
  ) async {
    final customerId = getIt<UserSessionCache>().getUser()?.customerId;
    final queryParameters = {
      'CustomerID': customerId.toString(),
      'ProductID': productId.toString(),
      "BarCode": barCode,
    };

    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.deleteOneItemFromBasket,
      queryParameters: queryParameters,
    );
    return result.fold((failure) => Left(failure), (response) {
      try {
        return const Right(null); // Success, return void
      } catch (e) {
        return Left(
          ParsingFailure(
            message: 'Failed to delete basket item: ${e.toString()}',
          ),
        );
      }
    });
  }
}
