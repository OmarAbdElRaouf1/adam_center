import 'package:equatable/equatable.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';

class AddressModel extends Equatable {
  final int? regionId;
  final String? regionName;
  final String? districtName;
  final String? streetName;
  final String? houseNo;
  final String? block;
  final String? floor;
  final String? apartment;
  final String? addressNotes;
  final String? customerAddress;
  final String? addressId;
  final String? arabicName;
  final String? englishName;
  final String? customerPhone;
  final bool isMain;

  const AddressModel({
    this.regionId,
    this.regionName,
    this.districtName,
    this.streetName,
    this.houseNo,
    this.block,
    this.floor,
    this.apartment,
    this.addressNotes,
    this.customerAddress,
    this.addressId,
    this.arabicName,
    this.englishName,
    this.customerPhone,
    this.isMain = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      regionId: json['region_id'] as int?,
      regionName: json['RegionName'] as String?,
      districtName: json['DistrictName'] as String?,
      streetName: json['StreetName'] as String?,
      houseNo: json['HouseNo'] as String?,
      block: json['Block'] as String?,
      floor: json['Floor'] as String?,
      apartment: json['Apartment'] as String?,
      addressNotes: json['AddressNotes'] as String?,
      customerAddress: json['CustomerAddress'] as String?,
      addressId: json['AddressID']?.toString(),
      arabicName: json['ArabicName'] as String?,
      englishName: json['EnglishName'] as String?,
      customerPhone: json['CustomerPhone'] as String?,
      isMain: json['MainAddress'] == 1,
    );
  }

  // The backend regenerates CustomerAddress server-side per address, so it's
  // the only field that actually varies per saved address (see
  // districtFromCustomerAddress's own doc comment for why).
  String? get districtLabel => districtFromCustomerAddress(customerAddress);

  AddressModel copyWith({String? regionName, String? districtName}) {
    return AddressModel(
      regionId: regionId,
      regionName: regionName ?? this.regionName,
      districtName: districtName ?? this.districtName,
      streetName: streetName,
      houseNo: houseNo,
      block: block,
      floor: floor,
      apartment: apartment,
      addressNotes: addressNotes,
      customerAddress: customerAddress,
      addressId: addressId,
      arabicName: arabicName,
      englishName: englishName,
      customerPhone: customerPhone,
      isMain: isMain,
    );
  }

  @override
  List<Object?> get props => [
    regionId,
    regionName,
    districtName,
    streetName,
    houseNo,
    block,
    floor,
    apartment,
    addressNotes,
    customerAddress,
    addressId,
    arabicName,
    englishName,
    customerPhone,
    isMain,
  ];
}
