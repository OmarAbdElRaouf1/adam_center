import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.customerId,
    required this.arabicName,
    required this.englishName,
    required this.customerPhone,
    required this.isNormal,
    required this.isActive,
    this.customerWork,
    this.customerNotes,
    this.webSite,
    this.lastName,
    this.email,
    this.regionId,
    this.regionName,
    this.placeId,
    this.districtName,
    this.streetName,
    this.gada,
    this.houseNo,
    this.block,
    this.floor,
    this.apartment,
    this.addressNotes,
    this.customerAddress,
    this.billValue,
    this.paymentMethod,
    this.deliveryValue,
    this.districtName2,
    this.districtEName,
    this.token,
    this.mapCustomerAddress,
    this.mapPlaceId,
    this.addressId,
    this.customerLastName,
    this.regionId3,
    this.regionName3,
    this.regionEName,
    this.addressNotes3,
    this.address,
    this.mainAddress,
    this.gender,
    this.birthDay,
    this.customerWork2,
    this.billNo,
    this.customerClassifyId,
    this.nationalityId,
    this.urlImgProfile,
    this.customerClassifyName,
    this.customerClassifyEName,
  });

  final int customerId;

  final String? arabicName;
  final String? englishName;
  final String customerPhone;

  final bool isNormal;
  final bool isActive;

  final String? customerWork;
  final String? customerNotes;
  final String? webSite;
  final String? lastName;
  final String? email;

  final int? regionId;
  final String? regionName;

  final int? placeId;
  final String? districtName;
  final String? streetName;
  final String? gada;
  final String? houseNo;
  final String? block;
  final String? floor;
  final String? apartment;
  final String? addressNotes;
  final String? customerAddress;

  final String? billValue;
  final String? paymentMethod;
  final String? deliveryValue;

  final String? districtName2;
  final String? districtEName;

  final String? token;

  final String? mapCustomerAddress;
  final String? mapPlaceId;
  final String? addressId;

  final String? customerLastName;

  final int? regionId3;
  final String? regionName3;
  final String? regionEName;
  final String? addressNotes3;

  final String? address;

  final int? mainAddress;
  final int? gender;

  final String? birthDay;
  final String? customerWork2;

  final int? billNo;
  final int? customerClassifyId;
  final int? nationalityId;

  final String? urlImgProfile;

  final String? customerClassifyName;
  final String? customerClassifyEName;

  UserModel copyWith({
    int? customerId,
    String? arabicName,
    String? englishName,
    String? customerPhone,
    bool? isNormal,
    bool? isActive,
    String? customerWork,
    String? customerNotes,
    String? webSite,
    String? lastName,
    String? email,
    int? regionId,
    String? regionName,
    int? placeId,
    String? districtName,
    String? streetName,
    String? gada,
    String? houseNo,
    String? block,
    String? floor,
    String? apartment,
    String? addressNotes,
    String? customerAddress,
    String? billValue,
    String? paymentMethod,
    String? deliveryValue,
    String? districtName2,
    String? districtEName,
    String? token,
    String? mapCustomerAddress,
    String? mapPlaceId,
    String? addressId,
    String? customerLastName,
    int? regionId3,
    String? regionName3,
    String? regionEName,
    String? addressNotes3,
    String? address,
    int? mainAddress,
    int? gender,
    String? birthDay,
    String? customerWork2,
    int? billNo,
    int? customerClassifyId,
    int? nationalityId,
    String? urlImgProfile,
    String? customerClassifyName,
    String? customerClassifyEName,
  }) {
    return UserModel(
      customerId: customerId ?? this.customerId,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      customerPhone: customerPhone ?? this.customerPhone,
      isNormal: isNormal ?? this.isNormal,
      isActive: isActive ?? this.isActive,
      customerWork: customerWork ?? this.customerWork,
      customerNotes: customerNotes ?? this.customerNotes,
      webSite: webSite ?? this.webSite,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      placeId: placeId ?? this.placeId,
      districtName: districtName ?? this.districtName,
      streetName: streetName ?? this.streetName,
      gada: gada ?? this.gada,
      houseNo: houseNo ?? this.houseNo,
      block: block ?? this.block,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      addressNotes: addressNotes ?? this.addressNotes,
      customerAddress: customerAddress ?? this.customerAddress,
      billValue: billValue ?? this.billValue,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryValue: deliveryValue ?? this.deliveryValue,
      districtName2: districtName2 ?? this.districtName2,
      districtEName: districtEName ?? this.districtEName,
      token: token ?? this.token,
      mapCustomerAddress: mapCustomerAddress ?? this.mapCustomerAddress,
      mapPlaceId: mapPlaceId ?? this.mapPlaceId,
      addressId: addressId ?? this.addressId,
      customerLastName: customerLastName ?? this.customerLastName,
      regionId3: regionId3 ?? this.regionId3,
      regionName3: regionName3 ?? this.regionName3,
      regionEName: regionEName ?? this.regionEName,
      addressNotes3: addressNotes3 ?? this.addressNotes3,
      address: address ?? this.address,
      mainAddress: mainAddress ?? this.mainAddress,
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      customerWork2: customerWork2 ?? this.customerWork2,
      billNo: billNo ?? this.billNo,
      customerClassifyId: customerClassifyId ?? this.customerClassifyId,
      nationalityId: nationalityId ?? this.nationalityId,
      urlImgProfile: urlImgProfile ?? this.urlImgProfile,
      customerClassifyName: customerClassifyName ?? this.customerClassifyName,
      customerClassifyEName:
          customerClassifyEName ?? this.customerClassifyEName,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      customerId: json['CustomerID'] ?? 0,

      arabicName: json['ArabicName'],
      englishName: json['EnglishName'],

      customerPhone: json['CustomerPhone'] ?? '',

      isNormal: json['IsNormal'] ?? false,
      isActive: json['IsActive'] ?? false,

      customerWork: json['Customer_Work'],
      customerNotes: json['CustomerNotes'],
      webSite: json['WebSite'],
      lastName: json['LastName'],
      email: json['Email'],

      regionId: json['region_id'],
      regionName: json['RegionName'],

      placeId: json['place_id'],
      districtName: json['DistrictName'],
      streetName: json['StreetName'],
      gada: json['Gada'],
      houseNo: json['HouseNo'],
      block: json['Block'],
      floor: json['Floor'],
      apartment: json['Apartment'],
      addressNotes: json['AddressNotes'],
      customerAddress: json['CustomerAddress'],

      billValue: json['BillValue'],
      paymentMethod: json['PaymentMethod'],
      deliveryValue: json['DeliveryValue'],

      districtName2: json['DistrictName2'],
      districtEName: json['DistrictEName'],

      token: json['Token'],

      mapCustomerAddress: json['MapCustomerAddress'],
      mapPlaceId: json['MapPlaceID'],
      addressId: json['AddressID'],

      customerLastName: json['CustomerLastName'],

      regionId3: json['RegionID3'],
      regionName3: json['Regionname3'],
      regionEName: json['RegionEname'],
      addressNotes3: json['AddressNotes3'],

      address: json['Address'],

      mainAddress: json['MainAddress'],
      gender: json['Gender'],

      birthDay: json['BirthDay'],
      customerWork2: json['CustomerWork'],

      billNo: json['BillNO'],
      customerClassifyId: json['CustomerClassifyId'],
      nationalityId: json['NationalityId'],

      urlImgProfile: json['URLImgProfile'],

      customerClassifyName: json['CustomerClassifyName'],
      customerClassifyEName: json['CustomerClassifyEName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustomerID': customerId,
      'ArabicName': arabicName,
      'EnglishName': englishName,
      'CustomerPhone': customerPhone,
      'IsNormal': isNormal,
      'IsActive': isActive,
      'Customer_Work': customerWork,
      'CustomerNotes': customerNotes,
      'WebSite': webSite,
      'LastName': lastName,
      'Email': email,
      'region_id': regionId,
      'RegionName': regionName,
      'place_id': placeId,
      'DistrictName': districtName,
      'StreetName': streetName,
      'Gada': gada,
      'HouseNo': houseNo,
      'Block': block,
      'Floor': floor,
      'Apartment': apartment,
      'AddressNotes': addressNotes,
      'CustomerAddress': customerAddress,
      'BillValue': billValue,
      'PaymentMethod': paymentMethod,
      'DeliveryValue': deliveryValue,
      'DistrictName2': districtName2,
      'DistrictEName': districtEName,
      'Token': token,
      'MapCustomerAddress': mapCustomerAddress,
      'MapPlaceID': mapPlaceId,
      'AddressID': addressId,
      'CustomerLastName': customerLastName,
      'RegionID3': regionId3,
      'Regionname3': regionName3,
      'RegionEname': regionEName,
      'AddressNotes3': addressNotes3,
      'Address': address,
      'MainAddress': mainAddress,
      'Gender': gender,
      'BirthDay': birthDay,
      'CustomerWork': customerWork2,
      'BillNO': billNo,
      'CustomerClassifyId': customerClassifyId,
      'NationalityId': nationalityId,
      'URLImgProfile': urlImgProfile,
      'CustomerClassifyName': customerClassifyName,
      'CustomerClassifyEName': customerClassifyEName,
    };
  }

  // Shared request-payload fragment for endpoints that identify the caller
  // by customer id + phone — spread into a request's `data`/`queryParameters`
  // map, e.g. `...UserModel.identityParams(user)`.
  static Map<String, dynamic> identityParams(UserModel? user) => {
    if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
    if (user != null) 'CustomerPhone': user.customerPhone,
  };

  @override
  List<Object?> get props => [
    customerId,
    arabicName,
    englishName,
    customerPhone,
    isNormal,
    isActive,
    customerWork,
    customerNotes,
    webSite,
    lastName,
    email,
    regionId,
    regionName,
    placeId,
    districtName,
    streetName,
    gada,
    houseNo,
    block,
    floor,
    apartment,
    addressNotes,
    customerAddress,
    billValue,
    paymentMethod,
    deliveryValue,
    districtName2,
    districtEName,
    token,
    mapCustomerAddress,
    mapPlaceId,
    addressId,
    customerLastName,
    regionId3,
    regionName3,
    regionEName,
    addressNotes3,
    address,
    mainAddress,
    gender,
    birthDay,
    customerWork2,
    billNo,
    customerClassifyId,
    nationalityId,
    urlImgProfile,
    customerClassifyName,
    customerClassifyEName,
  ];
}
