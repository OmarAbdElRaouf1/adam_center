import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/category_products/data/datasource/category_datasource.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';

part 'category_event.dart';

class CategoryBloc
    extends Bloc<CategoryEvent, BaseState<ParentCategoryModel>> {
  final CategoryDatasource categoryDatasource;

  CategoryBloc(this.categoryDatasource)
    : super(BaseState<ParentCategoryModel>()) {
    on<GetMainCategoriesEvent>(_onGetMainCategories);
  }

  Future<void> _onGetMainCategories(
    GetMainCategoriesEvent event,
    Emitter<BaseState<ParentCategoryModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await categoryDatasource.getMainCategories();

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (categories) {
        emit(state.copyWith(status: Status.success, items: categories));
      },
    );
  }
}
