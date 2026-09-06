import 'package:get_it/get_it.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/orders/data/datasource/orders_datasource.dart';
import 'package:the_one_test/features/orders/presentation/manager/orders_bloc/orders_bloc.dart';

class OrdersServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<OrdersDatasource>(
      () => OrdersDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );
    getIt.registerFactory<OrdersBloc>(
      () => OrdersBloc(getIt<OrdersDatasource>()),
    );
  }
}
