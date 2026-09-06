part of 'sub_category_bloc.dart';

class SubCategoryEvent extends Equatable {
  const SubCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetSubCategoriesEvent extends SubCategoryEvent {
  const GetSubCategoriesEvent(this.parentId);

  final int parentId;

  @override
  List<Object> get props => [parentId];
}
