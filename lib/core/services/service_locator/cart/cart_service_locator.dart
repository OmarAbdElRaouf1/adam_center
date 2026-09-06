import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/delete_cart_datasource.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';

class CartServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<AddToCartDataSource>(
      () => AddToCartDataSourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );

    getIt.registerLazySingleton<DeleteCartDataSource>(
      () => DeleteCartDataSourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerFactory<AddToCartBloc>(
      () => AddToCartBloc(addToCartDataSource: getIt<AddToCartDataSource>()),
    );

    getIt.registerFactory<CartBloc>(
      () => CartBloc(
        cartDataSource: getIt<AddToCartDataSource>(),
        deleteCartDataSource: getIt<DeleteCartDataSource>(),
      ),
    );
  }
}
