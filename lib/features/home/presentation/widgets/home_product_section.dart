import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/home/presentation/widgets/custom_row.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/more_products_grid_view.dart';

class HomeProductSection extends StatelessWidget {
  const HomeProductSection({
    super.key,
    required this.title,
    this.gap = 20,
    this.products,
    this.isLoading = false,
  });

  final String title;
  final double gap;
  final List<Map<String, String>>? products;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRow(
          title: title,
          seeAll: 'See All'.tr(),
          onSeeAllPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MoreProductsGridView(title: title, products: products),
            ),
          ),
        ),
        Gap(gap.h),
        if (isLoading)
          ProductListShimmer(height: context.screenHeight * 0.27)
        else if (products == null || products!.isEmpty)
          SizedBox(
            height: context.screenHeight * 0.3,
            child: EmptyStateWidget(message: 'No products yet'.tr()),
          )
        else
          HomeListView(products: products!),
      ],
    );
  }
}
