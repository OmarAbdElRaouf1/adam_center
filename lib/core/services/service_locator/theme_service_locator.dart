import 'package:get_it/get_it.dart';
import '../../local/hive_service_impl.dart';
import '../../bloc/theme_bloc/theme_bloc.dart';

class ThemeServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerFactory(() => ThemeBloc(themeCache: getIt<HiveServiceImpl>())..add(const ThemeLoaded()));
  }
}
