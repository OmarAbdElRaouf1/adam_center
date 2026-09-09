import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_one_test/features/account/data/datasource/change_password_datasource.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
  });

  final ChangePasswordStatus status;
  final String? errorMessage;

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordDatasource _changePasswordDatasource;

  ChangePasswordCubit(this._changePasswordDatasource)
    : super(const ChangePasswordState());

  Future<void> submit({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));
    final result = await _changePasswordDatasource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChangePasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ChangePasswordStatus.success)),
    );
  }
}
