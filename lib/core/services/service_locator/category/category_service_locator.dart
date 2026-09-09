import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/category_products/data/datasource/category_datasource.dart';
import 'package:the_one_test/features/category_products/data/datasource/product_datasource.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_selection_cubit/category_selection_cubit.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/sub_category_bloc/sub_category_bloc.dart';

class CategoryServiceLocator {
  static Future<void> init({required GetIt getIt}) async {
    getIt.registerLazySingleton<CategoryDatasource>(
      () => CategoryDatasourceImpl(getIt<GenericDataSource>()),
    );

    getIt.registerLazySingleton<CategorySelectionCubit>(
      () => CategorySelectionCubit(),
    );

    getIt.registerLazySingleton<ProductDatasource>(
      () => ProductDatasourceImpl(
        getIt<GenericDataSource>(),
        getIt<UserSessionCache>(),
      ),
    );

    getIt.registerFactory<CategoryBloc>(
      () => CategoryBloc(getIt<CategoryDatasource>()),
    );

    getIt.registerFactory<SubCategoryBloc>(
      () => SubCategoryBloc(getIt<CategoryDatasource>()),
    );

    getIt.registerFactory<ProductBloc>(
      () => ProductBloc(getIt<ProductDatasource>()),
    );
  }
}
