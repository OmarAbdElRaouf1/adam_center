import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/data/datasource/banner_datasource.dart';
import 'package:the_one_test/features/home/presentation/manager/banner_bloc/banner_bloc.dart';

class HomeServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<BannerDatasource>(
      () => BannerDatasourceImpl(getIt<GenericDataSource>()),
    );

    // Factory-with-param (not a plain factory) since BannerBloc needs a
    // runtime `endpoint` — several banner slots (Baner1/2/3) each resolve
    // their own instance from the same registration.
    getIt.registerFactoryParam<BannerBloc, String, void>(
      (endpoint, _) => BannerBloc(getIt<BannerDatasource>(), endpoint),
    );
  }
}
