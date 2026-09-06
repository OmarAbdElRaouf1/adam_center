import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
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

  // The backend's PayID scheme (0=Cash, 2=K-Net, 3=Visa, 4=Mastercard) has no
  // slot for this app's Wallet/Fawry methods, so those fall back to Cash (0)
  // until the backend defines real IDs for them.
  int _payId(PaymentMethod method) =>
      method == PaymentMethod.card ? 3 : 0;

  @override
  Future<Either<Failure, String>> placeOrder({
    required DeliveryInfoModel deliveryInfo,
    required PaymentMethod paymentMethod,
    required double subtotal,
    required double discount,
    required double total,
  }) async {
    final cartItemsResult = await _addToCartDataSource.getCartItems();
    if (cartItemsResult.isError) {
      return Left(cartItemsResult.throwError());
    }
    final cartItems = cartItemsResult.getOrThrow();

    final user = _userSessionDatasource.getUser();
    final now = DateTime.now().toIso8601String();

    final result = await _genericDataSource.postData<String>(
      endpoint: EndPoints.addOrder,
      data: {
        'OrderItems': cartItems
            .map(
              (item) => {
                'ItemID': item.productID,
                'ItemArMame': item.productName,
                'ItemEnNAme': item.productEnName,
                'Quantity': item.salesQuantity,
                'Price': item.price,
                'UnitId': 0,
                'UnitArName': '',
                'UnitEnName': '',
                'BarCode': item.barCode,
                'Colors_ID': 0,
                'ColorID': '',
                'ColorName': '',
                'ColorEName': '',
                'Size_ID': 0,
                'Size': '',
              },
            )
            .toList(),
        'OrderNo': 0,
        'BranchID': 0,
        'OrderDate': now,
        'DeliveryDate': now,
        if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
        if (user != null) 'CustomerPhone': user.customerPhone,
        'CustomerName': user?.arabicName ?? user?.englishName ?? '',
        'CustomerEnName': user?.englishName ?? '',
        'CustomerAddress': deliveryInfo.fullAddress,
        'OnlineStoreId': 0,
        'TotalValue': subtotal,
        'Discount': discount,
        'FinalValue': total,
        'PayID': _payId(paymentMethod),
        'DistrictName': deliveryInfo.area ?? '',
        'Street': deliveryInfo.street,
        'House': deliveryInfo.houseNumber,
        'Email': deliveryInfo.email,
        'OrderAddress': deliveryInfo.fullAddress,
      },
    );

    return result;
  }
}
