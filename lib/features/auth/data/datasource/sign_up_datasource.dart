import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

abstract class SignUpDatasource {
  Future<Either<Failure, UserModel>> signUp({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    String? notes,
    String? governorateName,
    String? districtName,
  });
}

class SignUpDatasourceImpl implements SignUpDatasource {
  final GenericDataSource genericDataSource;
  SignUpDatasourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    String? notes,
    String? governorateName,
    String? districtName,
  }) {
    return genericDataSource.postData<UserModel>(
      data: {
        "CustomerPhone": phone,
        "passWord": password,
        "Token": '1111',
        "ArabicName": firstName,
        "EnglishName": firstName,
        "LastName": lastName,
        "Email": email,
        if (notes != null && notes.isNotEmpty) "CustomerNotes": notes,
        "RegionName": ?governorateName,
        "DistrictName": ?districtName,
      },
      fromJson: UserModel.fromJson,
      endpoint: EndPoints.register,
    );
  }
}
