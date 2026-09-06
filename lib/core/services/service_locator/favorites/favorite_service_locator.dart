import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/favorites/data/datasource/favorite_datasource.dart';
import 'package:the_one_test/features/favorites/data/datasource/local_favorites_store.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';

class FavoriteServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<LocalFavoritesStore>(
      () => LocalFavoritesStore(getIt<SharedPreferences>()),
    );

    getIt.registerLazySingleton<FavoriteDatasource>(
      () => FavoriteDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
        getIt<LocalFavoritesStore>(),
      ),
    );

    getIt.registerFactory<FavoriteBloc>(
      () => FavoriteBloc(getIt<FavoriteDatasource>()),
    );
  }
}
