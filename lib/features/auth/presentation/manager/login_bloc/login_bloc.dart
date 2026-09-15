import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/datasource/login_datasource.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, BaseState<UserModel>> {
  final LoginDatasource loginDatasource;
  final UserSessionCache userSessionDatasource;
  final AccountCubit accountCubit;

  LoginBloc(this.loginDatasource, this.userSessionDatasource, this.accountCubit)
    : super(BaseState<UserModel>()) {
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<BaseState<UserModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await loginDatasource.login(event.phone, event.password);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (userModel) async {
        await accountCubit.updateUser(userModel);
        await userSessionDatasource.setLoggedIn(true);
        emit(
          state.copyWith(
            status: Status.success,
            data: userModel,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
