import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';

import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_selection_cubit/category_selection_cubit.dart';
import 'package:the_one_test/features/home/presentation/views/categories_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_category_circles.dart';

class ParentCategoryPreviewList extends StatelessWidget {
  const ParentCategoryPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    // Matches the reference: ~34% of the screen wide, label right under.
    final circleSize = context.screenWidth * 0.345;
    final height = circleSize + 48.h;

    return BlocBuilder<CategoryBloc, BaseState<ParentCategoryModel>>(
      builder: (context, state) {
        final parents = state.items;

        if (state.isLoading) {
          return SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) Gap(context.screenWidth * 0.12),
                  BlockShimmer(
                    width: circleSize * (i == 1 ? 1 : 0.5),
                    height: circleSize,
                    borderRadius: BorderRadius.circular(circleSize),
                  ),
                ],
              ],
            ),
          );
        }

        if (parents.isEmpty) return const SizedBox.shrink();

        return CarouselSlider.builder(
          itemCount: parents.length,
          options: CarouselOptions(
            height: height,
            viewportFraction: 0.47,
            enableInfiniteScroll: parents.length > 2,
          ),
          itemBuilder: (context, index, _) {
            final category = parents[index];

            return StoreCategoryCircle(
              data: StoreCircleItemData(
                title: category.title,
                image: category.image,
              ),
              size: circleSize,
              labelFontSize: 17,
              withRing: false,
              onTap: () {
                getIt<CategorySelectionCubit>().select(category.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoriesView()),
                );
              },
            );
          },
        );
      },
    );
  }
}
