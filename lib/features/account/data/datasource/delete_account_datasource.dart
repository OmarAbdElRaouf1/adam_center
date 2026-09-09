import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';

abstract interface class DeleteAccountDatasource {
  Future<Either<Failure, void>> deleteAccount();
}

class DeleteAccountDatasourceImpl implements DeleteAccountDatasource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;

  DeleteAccountDatasourceImpl(
    this._genericDataSource,
    this._userSessionDatasource,
  );

  // DELETE api/Customer/DeleteCustomerByCustomerID?CustomerID={CustomerID} —
  // confirmed against this backend's live Help page (unlike
  // Customer/ChangePassword, this route is actually registered).
  @override
  Future<Either<Failure, void>> deleteAccount() {
    final user = _userSessionDatasource.getUser();
    if (user == null || user.customerId == 0) {
      return Future.value(
        Left(AuthFailure(message: 'No account is currently signed in.')),
      );
    }
    return _genericDataSource.deleteData<void>(
      endpoint: EndPoints.deleteAccount,
      queryParameters: {'CustomerID': user.customerId},
    );
  }
}
