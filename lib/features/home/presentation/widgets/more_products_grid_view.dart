import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/product_sort.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_breadcrumb.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';

/// "See All" page for a home product section.
class MoreProductsGridView extends StatefulWidget {
  const MoreProductsGridView({super.key, required this.title, this.products});

  final String title;
  final List<Map<String, String>>? products;

  @override
  State<MoreProductsGridView> createState() => _MoreProductsGridViewState();
}

class _MoreProductsGridViewState extends State<MoreProductsGridView> {
  ProductSort _sort = ProductSort.newest;

  void _openSort() => showProductSortSheet(
    context,
    current: _sort,
    onSelected: (sort) => setState(() => _sort = sort),
  );

  @override
  Widget build(BuildContext context) {
    final products = widget.products ?? const <Map<String, String>>[];

    return StoreScaffold(
      body: Column(
        children: [
          StoreHeader(action: StoreHeaderFilterAction(onTap: _openSort)),
          Expanded(
            // Builder: body context, so the bottom inset includes the nav.
            child: Builder(
              builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 20.h,
                  bottom: MediaQuery.paddingOf(context).bottom + 40.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StoreBreadcrumb(current: widget.title),
                    Gap(14.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(16.h),
                    ProductSortField(
                      value: _sort,
                      onChanged: (sort) => setState(() => _sort = sort),
                    ),
                    CategoryProductsGrid(
                      products: _sort.apply(products),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
