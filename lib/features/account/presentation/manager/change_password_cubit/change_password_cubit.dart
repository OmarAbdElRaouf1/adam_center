import 'package:flutter_bloc/flutter_bloc.dart';

enum ChangePasswordStatus { initial, success }

class ChangePasswordCubit extends Cubit<ChangePasswordStatus> {
  ChangePasswordCubit() : super(ChangePasswordStatus.initial);

  void submit() => emit(ChangePasswordStatus.success);
}
