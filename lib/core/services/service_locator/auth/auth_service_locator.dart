import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/auth/data/datasource/district_datasource.dart';
import 'package:the_one_test/features/auth/data/datasource/governorate_datasource.dart';
import 'package:the_one_test/features/auth/data/datasource/login_datasource.dart';
import 'package:the_one_test/features/auth/data/datasource/sign_up_datasource.dart';
import 'package:the_one_test/features/auth/presentation/manager/district_bloc/district_bloc.dart';
import 'package:the_one_test/features/auth/presentation/manager/governorate_bloc/governorate_bloc.dart';
import 'package:the_one_test/features/auth/presentation/manager/login_bloc/login_bloc.dart';
import 'package:the_one_test/features/auth/presentation/manager/signup_bloc/signup_bloc.dart';

class AuthServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<LoginDatasource>(
      () => LoginDatasourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<SignUpDatasource>(
      () => SignUpDatasourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<GovernorateDatasource>(
      () => GovernorateDatasourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<DistrictDatasource>(
      () => DistrictDatasourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerFactory<LoginBloc>(
      () => LoginBloc(getIt<LoginDatasource>(), getIt<UserSessionCache>()),
    );

    getIt.registerFactory<SignupBloc>(
      () => SignupBloc(getIt<SignUpDatasource>(), getIt<UserSessionCache>()),
    );

    getIt.registerFactory<GovernorateBloc>(
      () => GovernorateBloc(getIt<GovernorateDatasource>()),
    );

    getIt.registerFactory<DistrictBloc>(
      () => DistrictBloc(getIt<DistrictDatasource>()),
    );
  }
}
