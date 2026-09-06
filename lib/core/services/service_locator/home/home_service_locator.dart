import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/data/datasource/banner_datasource.dart';

class HomeServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<BannerDatasource>(
      () => BannerDatasourceImpl(getIt<GenericDataSource>()),
    );
  }
}
