import 'package:easy_localization/easy_localization.dart';
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

    return GridView.builder(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return HomeListViewItem(
          key: ValueKey(product['id']),
          product: product,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsView(product: product),
            ),
          ),
        );
      },
    );
  }
}
