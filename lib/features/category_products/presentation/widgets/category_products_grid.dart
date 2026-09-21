import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view_item.dart';
import 'package:the_one_test/features/product_details/presentation/views/product_details_view.dart';

class CategoryProductsGrid extends StatelessWidget {
  const CategoryProductsGrid({
    super.key,
    required this.products,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final List<Map<String, String>> products;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.no_food_outlined,
        message: 'No products yet'.tr(),
      );
    }

    // Rows are sized by their tallest card — a fixed childAspectRatio
    // overflows as card content grows (category line, discount badge, larger
    // system font) — and the column count follows the available width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 190).floor().clamp(2, 4);
        final rowCount = (products.length / columns).ceil();
        return ListView.separated(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: rowCount,
          separatorBuilder: (_, _) => Gap(14.h),
          itemBuilder: (context, row) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var col = 0; col < columns; col++) ...[
                    if (col > 0) Gap(14.w),
                    Expanded(
                      child: row * columns + col < products.length
                          ? _buildItem(context, products[row * columns + col])
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, Map<String, String> product) {
    return HomeListViewItem(
      key: ValueKey(product['id']),
      product: product,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailsView(product: product)),
      ),
    );
  }
}
