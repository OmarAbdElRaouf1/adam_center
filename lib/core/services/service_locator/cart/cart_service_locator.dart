import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/add_to_cart_datasource.dart';
import 'package:the_one_test/features/cart/data/datasource/delete_cart_datasource.dart';
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
      () => DeleteCartDataSourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );

    // Singleton (not factory): every "add to cart" control across the app
    // (Home, Category, Favorites, Product Details, the Cart tab itself, and
    // Home's top-bar item count) needs to observe the exact same cart state.
    getIt.registerLazySingleton<CartBloc>(
      () => CartBloc(
        cartDataSource: getIt<AddToCartDataSource>(),
        deleteCartDataSource: getIt<DeleteCartDataSource>(),
        userSessionCache: getIt<UserSessionCache>(),
      ),
    );
  }
}
