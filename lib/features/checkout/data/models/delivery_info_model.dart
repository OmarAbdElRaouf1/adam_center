import 'package:equatable/equatable.dart';

class DeliveryInfoModel extends Equatable {
  const DeliveryInfoModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.area,
    required this.street,
    required this.houseNumber,
    required this.fullAddress,
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String? area;
  final String street;
  final String houseNumber;
  final String fullAddress;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phone,
    email,
    area,
    street,
    houseNumber,
    fullAddress,
  ];
}
