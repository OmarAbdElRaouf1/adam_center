import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';

/// Loading placeholder for a 2-column product grid, laid out with the exact
/// same GridView parameters as the real grid it stands in for
/// (CategoryProductsGrid) — so every row lines up evenly instead of the
/// staggered/masonry look of the core ProductGridShimmer.
class CategoryProductGridShimmer extends StatelessWidget {
  const CategoryProductGridShimmer({
    super.key,
    this.itemCount = 6,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}
