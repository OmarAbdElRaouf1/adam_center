import 'package:get_it/get_it.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/checkout/data/datasource/add_address_datasource.dart';
import 'package:the_one_test/features/checkout/data/datasource/place_order_datasource.dart';

class CheckoutServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<PlaceOrderDatasource>(
      () => PlaceOrderDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
        getIt<AddToCartDataSource>(),
      ),
    );
    getIt.registerLazySingleton<AddAddressDatasource>(
      () => AddAddressDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );
  }
}
