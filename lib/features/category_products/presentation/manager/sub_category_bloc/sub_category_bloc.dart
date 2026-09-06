import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/category_products/data/datasource/category_datasource.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';

part 'sub_category_event.dart';

class SubCategoryBloc
    extends Bloc<SubCategoryEvent, BaseState<SubCategoryModel>> {
  final CategoryDatasource categoryDatasource;

  SubCategoryBloc(this.categoryDatasource)
    : super(BaseState<SubCategoryModel>()) {
    on<GetSubCategoriesEvent>(_onGetSubCategories);
  }

  Future<void> _onGetSubCategories(
    GetSubCategoriesEvent event,
    Emitter<BaseState<SubCategoryModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await categoryDatasource.getSubCategories(event.parentId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (subCategories) {
        emit(state.copyWith(status: Status.success, items: subCategories));
      },
    );
  }
}
