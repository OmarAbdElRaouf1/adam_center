import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';

abstract interface class AddAddressDatasource {
  Future<Either<Failure, void>> addAddress({
    required int governorateId,
    required int areaId,
    required String districtName,
    required String street,
    required String houseNumber,
    String? gada,
    String? block,
    String? floor,
    String? apartment,
    String? notes,
    required String fullAddress,
    bool isMainAddress = false,
  });

  // Fetches the customer's real, currently-saved addresses straight from the
  // server (Customers/GetCustomerAddress) — used right after addAddress()
  // so the UI reflects what the backend actually stored, not a client-side
  // reconstruction of what was sent.
  Future<Either<Failure, Map<String, dynamic>?>> getMainAddress();

  // All of the customer's saved addresses, for a picker/list UI.
  Future<Either<Failure, List<Map<String, dynamic>>>> getAddresses();
}

class AddAddressDatasourceImpl implements AddAddressDatasource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;

  AddAddressDatasourceImpl(
    this._genericDataSource,
    this._userSessionDatasource,
  );

  // Field names confirmed against a real Customers/GetCustomerAddress
  // response (Customer/AddCustomerAddress itself has no documented sample —
  // the API's help page just shows an opaque encrypted-string body). Also
  // confirmed live: the backend requires CustomerPhone (not just
  // CustomerID), and every optional field must be an empty string rather
  // than JSON null — its parameterized SQL query treats a missing/null
  // value as "parameter not supplied" and 400s.
  @override
  Future<Either<Failure, void>> addAddress({
    required int governorateId,
    required int areaId,
    required String districtName,
    required String street,
    required String houseNumber,
    String? gada,
    String? block,
    String? floor,
    String? apartment,
    String? notes,
    required String fullAddress,
    bool isMainAddress = false,
  }) async {
    final user = _userSessionDatasource.getUser();
    final result = await _genericDataSource.postData<void>(
      endpoint: EndPoints.addNewAddress,
      data: {
        if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
        if (user != null) 'CustomerPhone': user.customerPhone,
        'region_id': governorateId,
        'place_id': areaId,
        'DistrictName': districtName,
        'StreetName': street,
        'HouseNo': houseNumber,
        'Gada': gada ?? '',
        'Block': block ?? '',
        'Floor': floor ?? '',
        'Apartment': apartment ?? '',
        'AddressNotes': notes ?? '',
        'CustomerAddress': fullAddress,
        'MainAddress': isMainAddress ? 1 : 0,
      },
    );
    return result;
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getMainAddress() async {
    final result = await getAddresses();
    return result.fold(
      (failure) => Left(failure),
      (addresses) {
        if (addresses.isEmpty) return const Right(null);
        final main = addresses.where((a) => a['MainAddress'] == 1);
        return Right(main.isNotEmpty ? main.first : addresses.last);
      },
    );
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAddresses() {
    final user = _userSessionDatasource.getUser();
    return _genericDataSource.fetchData<Map<String, dynamic>>(
      endpoint: EndPoints.savedAddresses,
      queryParameters: {
        if (user != null) 'CustomerPhone': user.customerPhone,
      },
      fromJson: (json) => json,
    );
  }
}
