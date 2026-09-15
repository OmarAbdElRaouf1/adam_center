import 'package:gap/gap.dart';

import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_selection_cubit/category_selection_cubit.dart';
import 'package:the_one_test/features/home/presentation/views/categories_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/categories_grid_view_item.dart';

class ParentCategoryPreviewList extends StatelessWidget {
  const ParentCategoryPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, BaseState<ParentCategoryModel>>(
      builder: (context, state) {
        final parents = state.items;

        if (state.isLoading) {
          return SizedBox(
            height: context.screenHeight * 0.15,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w),
              itemCount: 4,
              separatorBuilder: (_, _) => Gap(12.w),
              itemBuilder: (context, index) => SizedBox(
                width: context.screenWidth * 0.25,
                child: const CategoryTileShimmer(),
              ),
            ),
          );
        }

        return SizedBox(
          height: context.screenHeight * 0.15,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w),
            itemCount: parents.length,
            separatorBuilder: (_, _) => Gap(12.w),
            itemBuilder: (context, index) {
              final category = parents[index];

              return SizedBox(
                width: context.screenWidth * 0.25,
                child: CategoriesListViewItem(
                  title: category.title,
                  image: category.image,
                  onTap: () {
                    getIt<CategorySelectionCubit>().select(category.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CategoriesView()),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
