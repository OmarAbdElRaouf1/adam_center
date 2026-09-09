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

    // Singleton (not factory): a toggle on one screen (e.g. Favorites) must
    // be observed by every FavoriteToggleButton across the app (Home,
    // Category, Product Details), which only works if they all share the
    // same bloc instance.
    getIt.registerLazySingleton<FavoriteBloc>(
      () => FavoriteBloc(getIt<FavoriteDatasource>()),
    );
  }
}
