part of 'signup_bloc.dart';

class SignupEvent extends Equatable {
  const SignupEvent({
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.notes,
    this.governorateName,
    this.districtName,
  });

  final String password;
  final String phone;
  final String firstName;
  final String lastName;
  final String email;
  final String? notes;
  final String? governorateName;
  final String? districtName;

  @override
  List<Object?> get props => [
    phone,
    password,
    firstName,
    lastName,
    email,
    notes,
    governorateName,
    districtName,
  ];
}
