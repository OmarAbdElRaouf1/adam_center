import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

abstract interface class ChangePasswordDatasource {
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class ChangePasswordDatasourceImpl implements ChangePasswordDatasource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;

  ChangePasswordDatasourceImpl(
    this._genericDataSource,
    this._userSessionDatasource,
  );

  // Customer/ChangePassword has no documented sample on the API's help page
  // (same situation as Customer/AddCustomerAddress) — field names follow
  // this backend's Customer/Login & Customer/AddCustomer convention
  // ("passWord") and need confirming against a live response if the backend
  // rejects them.
  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = _userSessionDatasource.getUser();
    return _genericDataSource.postData<void>(
      endpoint: EndPoints.changePassword,
      data: {
        ...UserModel.identityParams(user),
        'OldPassWord': oldPassword,
        'passWord': newPassword,
      },
    );
  }
}
