import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/datasource/sign_up_datasource.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

part 'signup_event.dart';

class SignupBloc extends Bloc<SignupEvent, BaseState<UserModel>> {
  final SignUpDatasource signUpDatasource;
  final UserSessionCache userSessionDatasource;
  final AccountCubit accountCubit;

  SignupBloc(
    this.signUpDatasource,
    this.userSessionDatasource,
    this.accountCubit,
  ) : super(BaseState<UserModel>()) {
    on<SignupEvent>(_onSignup);
  }

  Future<void> _onSignup(
    SignupEvent event,
    Emitter<BaseState<UserModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await signUpDatasource.signUp(
      phone: event.phone,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      notes: event.notes,
      governorateName: event.governorateName,
      districtName: event.districtName,
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (userModel) async {
        await accountCubit.updateUser(userModel);
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
