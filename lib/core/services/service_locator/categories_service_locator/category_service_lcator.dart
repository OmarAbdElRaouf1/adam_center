// import 'package:issa_baba/feature/main/catagory/data_source/sub_categories_data_source.dart';
// import 'package:issa_baba/feature/main/catagory/data_source/sub_category_products_data_source.dart';
// import 'package:issa_baba/feature/main/catagory/manager/sub_categories_bloc/sub_categories_bloc.dart';
// import 'package:issa_baba/feature/main/catagory/manager/sub_sub_categories_bloc/sub_sub_category_bloc.dart';
// import 'package:get_it/get_it.dart';

// import '../../../../../../feature/main/catagory/manager/sub_category_products_bloc/sub_category_products_bloc.dart';
// import '../../../datasource/generic_data_source.dart';

//   class CategoriesServiceLocator {
//   static Future<void> init({required GetIt getIt}) async {
//     getIt.registerLazySingleton<SubCategoryDataSource>(
//       () => SubCategoryDataSourceImpl(getIt<GenericDataSource>()),
//     );
//     getIt.registerLazySingleton<SubCategoryProductsDataSource>(
//       () => SubCategoryProductsDataSourceImpl(getIt<GenericDataSource>()),
//     );

//     getIt.registerFactory<SubCategoryBloc>(
//       () => SubCategoryBloc(
//         subCategoryDataSource: getIt<SubCategoryDataSource>(),
//       ),
//     );
//     getIt.registerFactory<SubSubCategoryBloc>(
//       () => SubSubCategoryBloc(
//         subCategoryDataSource: getIt<SubCategoryDataSource>(),
//       ),
//     );
//     getIt.registerFactory<SubCategoryProductBloc>(
//           () => SubCategoryProductBloc(
//         dataSource: getIt<SubCategoryProductsDataSource>(),
//       ),
//     );
//   }
// }
