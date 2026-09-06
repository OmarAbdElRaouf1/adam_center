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
  Future<Either<Failure, List<OrderModel>>> getOrders() {
    final user = _userSessionDatasource.getUser();
    return _genericDataSource.fetchData<OrderModel>(
      endpoint: EndPoints.getPreviousOrders,
      queryParameters: {
        if (user != null && user.customerId != 0) 'CustomerID': user.customerId,
      },
      fromJson: OrderModel.fromJson,
    );
  }
}
