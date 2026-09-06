import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

class AccountCubit extends Cubit<UserModel?> {
  AccountCubit(UserSessionCache userSessionCache)
    : super(userSessionCache.getUser());
}
