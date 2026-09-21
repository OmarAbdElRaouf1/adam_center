import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_product_grid_shimmer.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';
import 'package:the_one_test/features/home/presentation/widgets/custom_row.dart';
import 'package:the_one_test/features/home/presentation/widgets/fetched_banner_section.dart';
import 'package:the_one_test/features/home/presentation/widgets/fetched_product_section.dart';
import 'package:the_one_test/features/home/presentation/widgets/parent_category_preview_list.dart';
import 'package:the_one_test/features/home/presentation/widgets/text_banner.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
    required this.searchController,
    required this.isSearching,
    required this.searchBloc,
    required this.onSeeAllPressed,
    required this.dispatchSearch,
  });

  final TextEditingController searchController;
  final bool isSearching;
  final ProductBloc searchBloc;

  final VoidCallback onSeeAllPressed;
  final void Function(String query) dispatchSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isSearching)
          BlocBuilder<ProductBloc, BaseState<ItemModel>>(
            bloc: searchBloc,
            builder: (context, state) {
              if (state.isLoading || state.isInitial) {
                return const CategoryProductGridShimmer(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                );
              }

              if (state.isFailure) {
                return FailureWidget(
                  state: state,
                  errorMessage: state.errorMessage ?? '',
                  onRetry: () {
                    dispatchSearch(searchController.text.trim());
                  },
                );
              }

              final products = state.items
                  .map((item) => item.toProductMap())
                  .toList();

              return CategoryProductsGrid(
                products: products,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              );
            },
          )
        else ...[
          FetchedBannerSlider(endpoint: EndPoints.bannerOne),

          Gap(20.h),

          const TextBanner(),

          Gap(20.h),

          CustomRow(
            title: 'Categories'.tr(),
            seeAll: 'See All'.tr(),
            onSeeAllPressed: onSeeAllPressed,
          ),

          Gap(20.h),

          const ParentCategoryPreviewList(),

          Gap(20.h),

          FetchedProductSection(
            title: 'New Products'.tr(),
            event: const GetNewProductsEvent(),
          ),

          Gap(20.h),

          FetchedBannerSlider(endpoint: EndPoints.bannerTwo),

          Gap(20.h),

          FetchedProductSection(
            title: 'Best Sellers'.tr(),
            event: const GetBestSellersEvent(),
            gap: 10,
          ),

          Gap(20.h),

          FetchedProductSection(
            title: 'Discounted Products'.tr(),
            event: const GetBiggestDiscountProductsEvent(),
            gap: 10,
          ),

          Gap(20.h),

          FetchedBannerSlider(endpoint: EndPoints.bannerThree),

          // Gap(40.h),
        ],
      ],
    );
  }
}
