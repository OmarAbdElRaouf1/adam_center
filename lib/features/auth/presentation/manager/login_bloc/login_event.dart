part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent({required this.phone, required this.password});

  final String phone;
  final String password;

  @override
  List<Object> get props => [phone, password];
}
