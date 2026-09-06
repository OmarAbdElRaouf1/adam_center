import 'package:get_it/get_it.dart';
import 'package:the_one_test/features/orders/data/datasource/orders_datasource.dart';
import 'package:the_one_test/features/orders/presentation/manager/orders_bloc/orders_bloc.dart';

class OrdersServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<OrdersDatasource>(
      () => OrdersDatasourceImpl(),
    );
    getIt.registerFactory<OrdersBloc>(
      () => OrdersBloc(getIt<OrdersDatasource>()),
    );
  }
}
