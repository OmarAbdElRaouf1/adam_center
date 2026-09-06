import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/api_consumer.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/network/encrupt.dart';
import 'package:the_one_test/core/services/service_locator/account/account_service_locator.dart';
import 'package:the_one_test/core/services/service_locator/auth/auth_service_locator.dart';
import 'package:the_one_test/core/services/service_locator/cart/cart_service_locator.dart';
import 'package:the_one_test/core/services/service_locator/category/category_service_locator.dart';
import 'package:the_one_test/core/services/service_locator/favorites/favorite_service_locator.dart';
import 'package:the_one_test/core/services/service_locator/home/home_service_locator.dart';
import 'package:the_one_test/core/services/service_locator/orders/orders_service_locator.dart';
import '../../constant/end_points.dart';
import '../../helper/connectivity_service.dart';
import '../../helper/sync_manager.dart';

import 'hive_service_locator/hive_service_locator.dart';
import 'theme_service_locator.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerLazySingleton<Dio>(
    () =>
        Dio(
            BaseOptions(
              baseUrl: EndPoints.baseUrl,
              receiveDataWhenStatusError: true,
              connectTimeout: const Duration(seconds: 30),
              // Add this to avoid quick timeouts
              receiveTimeout: const Duration(seconds: 30),
              // Add this too
              sendTimeout: const Duration(seconds: 30),
              headers: {
                'Accept': 'application/json',
                'Accept-Language': 'ar',
                'Authorization': basicToken,
              },
            ),
          )
          ..interceptors.add(
            LogInterceptor(
              request: true,
              requestHeader: true,
              requestBody: true,
              responseHeader: true,
              responseBody: true,
              error: true,
            ),
          ),
  );
  getIt.registerLazySingleton<ApiConsumer>(
    () => BaseApiConsumer(
      dio: getIt<Dio>(),
      privateKey: privateKey,
      publicKey: publicKey,
    ),
  );
  getIt.registerLazySingleton<GenericDataSource>(
    () => GenericDataSource(getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService.instance,
  );

  getIt.registerSingleton<SyncManager>(SyncManager());

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<UserSessionCache>(
    () => UserSessionCacheImpl(getIt<SharedPreferences>()),
  );
  await HiveServiceLocator.init(getIt: getIt);
  await ThemeServiceLocator.init(getIt: getIt);
  await AuthServiceLocator.init(getIt: getIt);
  await CategoryServiceLocator.init(getIt: getIt);
  await HomeServiceLocator.init(getIt: getIt);
  await CartServiceLocator.init(getIt: getIt);
  await FavoriteServiceLocator.init(getIt: getIt);
  await OrdersServiceLocator.init(getIt: getIt);
  await AccountServiceLocator.init(getIt: getIt);
}
