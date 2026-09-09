part of 'add_address_bloc.dart';

abstract class AddAddressEvent extends Equatable {
  const AddAddressEvent();

  @override
  List<Object?> get props => [];
}

class SaveAddress extends AddAddressEvent {
  final int governorateId;
  final int areaId;
  final String districtName;
  final String street;
  final String houseNumber;
  final String? block;
  final String? floor;
  final String? apartment;
  final String? notes;
  final String fullAddress;

  const SaveAddress({
    required this.governorateId,
    required this.areaId,
    required this.districtName,
    required this.street,
    required this.houseNumber,
    this.block,
    this.floor,
    this.apartment,
    this.notes,
    required this.fullAddress,
  });

  @override
  List<Object?> get props => [
    governorateId,
    areaId,
    districtName,
    street,
    houseNumber,
    block,
    floor,
    apartment,
    notes,
    fullAddress,
  ];
}
