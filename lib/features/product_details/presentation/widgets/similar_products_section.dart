import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_section_title.dart';

class SimilarProductsSection extends StatelessWidget {
  const SimilarProductsSection({
    super.key,
    required this.excludeName,
    required this.categoryId,
  });

  final String excludeName;
  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    if (categoryId == null) return const SizedBox.shrink();

    return BlocProvider(
      create: (context) =>
          getIt<ProductBloc>()..add(GetProductsByCategoryEvent(categoryId!)),
      child: BlocBuilder<ProductBloc, BaseState<ItemModel>>(
        builder: (context, state) {
          final items = state.items
              .where((item) => item.productArName != excludeName)
              .map((item) => item.toProductMap())
              .toList();

          if (!state.isLoading && items.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSectionTitle(
                title: 'Similar Products'.tr(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
              ),
              Gap(20.h),
              if (state.isLoading)
                ProductListShimmer(height: context.screenWidth * 0.75)
              else
                HomeListView(products: items),
            ],
          );
        },
      ),
    );
  }
}
