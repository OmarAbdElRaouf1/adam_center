import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';

abstract interface class CategoryDatasource {
  Future<Either<Failure, List<ParentCategoryModel>>> getMainCategories();
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
    int parentId,
  );
}

class CategoryDatasourceImpl implements CategoryDatasource {
  final GenericDataSource _genericDataSource;
  CategoryDatasourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<ParentCategoryModel>>> getMainCategories() {
    return _genericDataSource.fetchData<ParentCategoryModel>(
      endpoint: EndPoints.getMainCategory,
      fromJson: ParentCategoryModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<SubCategoryModel>>> getSubCategories(
    int parentId,
  ) {
    return _genericDataSource.fetchData<SubCategoryModel>(
      endpoint: EndPoints.getSubCategory,
      queryParameters: {'Parent': parentId},
      fromJson: SubCategoryModel.fromJson,
    );
  }
}
