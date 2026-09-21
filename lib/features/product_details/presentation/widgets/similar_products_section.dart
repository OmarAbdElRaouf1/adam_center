import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_product_grid_shimmer.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';

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
          if (state.isLoading) {
            return const CategoryProductGridShimmer(
              itemCount: 4,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            );
          }

          final items = state.items
              .where((item) => item.productArName != excludeName)
              .map((item) => item.toProductMap())
              .toList();

          if (items.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Similar Products'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Gap(12.h),
              CategoryProductsGrid(
                products: items,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          );
        },
      ),
    );
  }
}
