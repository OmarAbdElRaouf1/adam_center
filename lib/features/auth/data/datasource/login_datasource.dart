import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

abstract class LoginDatasource {
  Future<Either<Failure, UserModel>> login(String phone, String password);
}

class LoginDatasourceImpl implements LoginDatasource {
  final GenericDataSource genericDataSource;
  LoginDatasourceImpl(this.genericDataSource);
  @override
  Future<Either<Failure, UserModel>> login(String phone, String password) {
    return genericDataSource.fetchResult<UserModel>(
      queryParameters: {
        "CustomerPhone": phone,
        "passWord": password,
        "Token": '1111',
      },
      fromJson: (UserModel.fromJson),

      endpoint: EndPoints.login,
    );
  }
}
