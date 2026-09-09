import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/account/data/datasource/change_password_datasource.dart';
import 'package:the_one_test/features/account/data/datasource/delete_account_datasource.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/account/presentation/manager/change_password_cubit/change_password_cubit.dart';

class AccountServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<DeleteAccountDatasource>(
      () => DeleteAccountDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );
    getIt.registerLazySingleton<AccountCubit>(
      () => AccountCubit(
        getIt<UserSessionCache>(),
        getIt<DeleteAccountDatasource>(),
      ),
    );
    getIt.registerLazySingleton<ChangePasswordDatasource>(
      () => ChangePasswordDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );
    getIt.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(getIt<ChangePasswordDatasource>()),
    );
  }
}
