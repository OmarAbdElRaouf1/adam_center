import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/orders/data/models/order_model.dart';

abstract interface class OrdersDatasource {
  Future<Either<Failure, List<OrderModel>>> getOrders();
}

class OrdersDatasourceImpl implements OrdersDatasource {
  static const _address = OrderAddress(
    area: 'الاندلس',
    block: '1',
    street: '1',
    avenue: '1',
    house: '1',
    floor: '1',
    apartment: '1',
  );

  static const List<OrderModel> _orders = [
    OrderModel(
      orderNumber: '003',
      date: '20-11-2024',
      status: OrderStatus.preparing,
      address: _address,
      totalPrice: 10,
      isPrevious: false,
    ),
    OrderModel(
      orderNumber: '004',
      date: '21-11-2024',
      status: OrderStatus.onTheWay,
      address: _address,
      totalPrice: 10,
      isPrevious: false,
    ),
    OrderModel(
      orderNumber: '001',
      date: '16-11-2024',
      status: OrderStatus.received,
      address: _address,
      totalPrice: 10,
      isPrevious: true,
    ),
    OrderModel(
      orderNumber: '002',
      date: '16-11-2024',
      status: OrderStatus.cancelled,
      address: _address,
      totalPrice: 10,
      isPrevious: true,
    ),
  ];

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    return const Right(_orders);
  }
}
