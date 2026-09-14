import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/checkout/data/models/delivery_info_model.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/payment_methods_section.dart';

abstract interface class PlaceOrderDatasource {
  Future<Either<Failure, String>> placeOrder({
    required DeliveryInfoModel deliveryInfo,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double discount,
    required double total,
  });
}

class PlaceOrderDatasourceImpl implements PlaceOrderDatasource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;
  final AddToCartDataSource _addToCartDataSource;

  PlaceOrderDatasourceImpl(
    this._genericDataSource,
    this._userSessionDatasource,
    this._addToCartDataSource,
  );

  @override
  Future<Either<Failure, String>> placeOrder({
    required DeliveryInfoModel deliveryInfo,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double discount,
    required double total,
  }) async {
    final cartItemsResult = await _addToCartDataSource.getCartItems();
    return cartItemsResult.fold(
      (failure) => Left(failure),
      (cartItems) => _placeOrderForCartItems(
        cartItems: cartItems,
        deliveryInfo: deliveryInfo,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        discount: discount,
        total: total,
      ),
    );
  }

  Future<Either<Failure, String>> _placeOrderForCartItems({
    required List<CartItemModel> cartItems,
    required DeliveryInfoModel deliveryInfo,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double discount,
    required double total,
  }) async {
    final user = _userSessionDatasource.getUser();
    final now = DateTime.now().toIso8601String();

    // This backend's Order stored procedure requires every parameter in its
    // Help-page sample to be present (missing ones silently fail the whole
    // insert and it just returns "-1" with no error). The only
    // CompanyBranches/Stores row on this backend has ID 1, so BranchID and
    // OnlineStoreId must be 1, not 0.
    //
    // NOTE: even with every field from the Help-page sample populated
    // (including the sample's duplicated "_OrderItems"/"OrderItems" keys,
    // NotAllowNegativeOutput: true, and a UTC OrderDate/DeliveryDate), a live
    // call against this backend on 2026-09-07 still returned "-1"
    // byte-for-byte identically across several different payloads (different
    // items, addresses, discount, boolean/date variations). That points to a
    // server-side failure in the Order stored procedure itself (or the "test"
    // environment's write path being unavailable) rather than anything
    // missing from this request — needs backend-side investigation/logs.
    final orderItems = cartItems
        .asMap()
        .entries
        .map(
          (entry) => {
            'OrderNo': 0,
            'Number': entry.key + 1,
            'ItemID': entry.value.productID,
            'ItemArMame': entry.value.productName,
            'ItemEnNAme': entry.value.productEnName,
            'Quantity': entry.value.salesQuantity,
            'Price': entry.value.price,
            'UnitId': 0,
            'UnitArName': '',
            'UnitEnName': '',
            'BarCode': entry.value.barCode,
            'Colors_ID': 0,
            'ColorID': '',
            'ColorName': '',
            'ColorEName': '',
            'Size_ID': 0,
            'Size': '',
          },
        )
        .toList();

    final orderData = {
      'OrderItems': orderItems,
      'OrderNo': 0,
      'BranchID': 1,
      'OrderDate': now,
      'DeliveryDate': now,
      ...UserModel.identityParams(user),
      'CustomerName': user?.arabicName ?? user?.englishName ?? '',
      'CustomerEnName': user?.englishName ?? '',
      'CustomerAddress': deliveryInfo.fullAddress,
      'OnlineStoreId': 1,
      'TotalValue': subtotal,
      'Details': '',
      'Additions': 0.0,
      'OrderTime': '',
      'Discount': discount,
      'FinalValue': total,
      'AdditionalDescription1': 0.0,
      'AdditionalDescription2': 0.0,
      'AdditionalDescription3': 0.0,
      'AdditionalDescription4': 0.0,
      'AdditionalDescription5': 0.0,
      'AdditionalDescription6': 0.0,
      'AdditionalDescription7': 0.0,
      'AdditionalDescription8': 0.0,
      'AdditionalDescription9': 0.0,
      'AdditionalDescription10': 0.0,
      'SalesManID': 0,
      'SalesManName': '',
      'Description1': '',
      'Description2': '',
      'Description3': '',
      'RefrenceNumber': '',
      'UserID': 0,
      'UserName': '',
      'TaxesPercent': 0.0,
      'TaxesValue': 0.0,
      'PayID': 0,
      'PayValue': total,
      'DistrictName': deliveryInfo.area ?? '',
      'Block': '',
      'Street': deliveryInfo.street,
      'House': deliveryInfo.houseNumber,
      'PaymentID': '',
      'GroupID': 0,
      'SecondPhone': '',
      'Gada': '',
      'Email': deliveryInfo.email,
      'Floor': '',
      'Apartment': '',
      'DeliveryDay': '',
      'DeliveryID': 0,
      'OrderAddress': deliveryInfo.fullAddress,
      'DiscountCode': '',
      'ParentAcID': 0,
      'DiscountCardValue': 0.0,
      'MapCustomerAddress': '',
      'MapPlaceID': '',
      'DiscountPointsValue': 0.0,
      'RegionName': '',
      'NotAllowNegativeOutput': false,
    };

    final result = await _genericDataSource.postData<String>(
      endpoint: EndPoints.addOrder,
      data: orderData,
    );

    return result.fold((failure) => Left(failure), (orderNumber) {
      if (orderNumber == '-1' || orderNumber == '-1.0') {
        return Left(
          ServerFailure(
            message: 'Order could not be placed. Please try again.',
          ),
        );
      }
      return Right(orderNumber);
    });
  }
}
