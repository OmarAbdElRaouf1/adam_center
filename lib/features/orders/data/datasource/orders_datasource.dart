import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/orders/data/models/order_model.dart';

abstract interface class OrdersDatasource {
  Future<Either<Failure, List<OrderModel>>> getOrders();
}

class OrdersDatasourceImpl implements OrdersDatasource {
  final GenericDataSource _genericDataSource;
  final UserSessionCache _userSessionDatasource;

  OrdersDatasourceImpl(this._genericDataSource, this._userSessionDatasource);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    final user = _userSessionDatasource.getUser();
    final result = await _genericDataSource.fetchData<OrderModel>(
      endpoint: EndPoints.getPreviousOrders,
      queryParameters: {
        // Intentionally CustomerID only (no CustomerPhone) — not the same
        // shape as UserModel.identityParams, do not consolidate.
        if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
      },
      fromJson: OrderModel.fromJson,
    );
    return result.fold((failure) => Left(failure), (orders) async {
      final withItems = await Future.wait(orders.map(_withItems));
      return Right(withItems);
    });
  }

  // A failed items call leaves that order without a product list rather than
  // failing the whole orders screen.
  Future<OrderModel> _withItems(OrderModel order) async {
    final result = await _genericDataSource.fetchData<OrderItemModel>(
      endpoint: EndPoints.getOrdersDetails,
      queryParameters: {'OrderNo': order.orderNumber},
      fromJson: OrderItemModel.fromJson,
    );
    return result.fold((_) => order, (items) => order.copyWith(items: items));
  }
}
