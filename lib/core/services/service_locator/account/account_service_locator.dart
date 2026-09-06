import 'package:get_it/get_it.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';

class AccountServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerFactory<AccountCubit>(
      () => AccountCubit(getIt<UserSessionCache>()),
    );
  }
}
