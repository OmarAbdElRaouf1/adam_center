import 'package:equatable/equatable.dart';

/// Contact + address entered on the checkout page.
class DeliveryInfoModel extends Equatable {
  const DeliveryInfoModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.governorate,
    required this.area,
    required this.block,
    required this.street,
    required this.gada,
    required this.house,
    required this.floor,
    required this.apartment,
    required this.notes,
  });

  /// Placeholder until the checkout form is submitted.
  static const empty = DeliveryInfoModel(
    name: '',
    phone: '',
    email: '',
    governorate: '',
    area: '',
    block: '',
    street: '',
    gada: '',
    house: '',
    floor: '',
    apartment: '',
    notes: '',
  );

  final String name;
  final String phone;
  final String email;
  final String governorate;
  final String area;
  final String block;
  final String street;
  final String gada;
  final String house;
  final String floor;
  final String apartment;
  final String notes;

  /// One-line address for the order's address fields.
  String get fullAddress => [
    governorate,
    area,
    if (block.isNotEmpty) 'قطعة $block',
    if (street.isNotEmpty) 'شارع $street',
    if (gada.isNotEmpty) 'جادة $gada',
    if (house.isNotEmpty) 'منزل $house',
    if (floor.isNotEmpty) 'طابق $floor',
    if (apartment.isNotEmpty) 'شقة $apartment',
  ].where((part) => part.isNotEmpty).join('، ');

  @override
  List<Object?> get props => [
    name,
    phone,
    email,
    governorate,
    area,
    block,
    street,
    gada,
    house,
    floor,
    apartment,
    notes,
  ];
}
