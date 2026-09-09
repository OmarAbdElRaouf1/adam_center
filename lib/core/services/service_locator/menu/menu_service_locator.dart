import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/menu/data/datasource/info_pages_datasource.dart';

class MenuServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<InfoPagesDatasource>(
      () => InfoPagesDatasourceImpl(getIt<GenericDataSource>()),
    );
  }
}
