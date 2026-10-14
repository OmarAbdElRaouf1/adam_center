import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_product_grid_shimmer.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/product_sort.dart';
import 'package:the_one_test/features/home/presentation/widgets/floating_header_layout.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_breadcrumb.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_category_circles.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_pull_to_refresh.dart';

class CategoryProductsView extends StatelessWidget {
  const CategoryProductsView({
    super.key,
    required this.subCategory,
    this.siblings = const [],
    this.parentTitle,
  });

  final SubCategoryModel subCategory;

  /// Main category the subcategory belongs to, shown in the breadcrumb.
  final String? parentTitle;

  /// The other subcategories of the same parent, shown as a circle row to
  /// switch between without going back.
  final List<SubCategoryModel> siblings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductBloc>(),
      child: _CategoryProductsBody(
        key: ValueKey(context.locale.languageCode),
        subCategory: subCategory,
        siblings: siblings,
        parentTitle: parentTitle,
      ),
    );
  }
}

class _CategoryProductsBody extends StatefulWidget {
  const _CategoryProductsBody({
    super.key,
    required this.subCategory,
    required this.siblings,
    this.parentTitle,
  });

  final SubCategoryModel subCategory;
  final List<SubCategoryModel> siblings;
  final String? parentTitle;

  @override
  State<_CategoryProductsBody> createState() => _CategoryProductsBodyState();
}

class _CategoryProductsBodyState extends State<_CategoryProductsBody> {
  late SubCategoryModel _selected = widget.subCategory;
  ProductSort _sort = ProductSort.newest;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<ProductBloc>().add(
      GetProductsByCategoryEvent(_selected.id ?? 0),
    );
  }

  void _select(SubCategoryModel sub) {
    if (sub == _selected) return;
    setState(() => _selected = sub);
    _load();
  }

  void _openSort() => showProductSortSheet(
    context,
    current: _sort,
    onSelected: (sort) => setState(() => _sort = sort),
  );

  @override
  Widget build(BuildContext context) {
    final siblings = widget.siblings;

    return StoreScaffold(
      body: FloatingHeaderLayout(
        header: StoreHeader(action: StoreHeaderFilterAction(onTap: _openSort)),
        bodyBuilder: (context, topInset) => StorePullToRefresh(
          topInset: topInset,
          onRefresh: () {
            _load();
            return untilLoaded(context.read<ProductBloc>());
          },
          builder: (controller) => SingleChildScrollView(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: topInset + 20.h,
              bottom: MediaQuery.paddingOf(context).bottom + 40.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StoreBreadcrumb(current: widget.parentTitle ?? _selected.title),
                Gap(14.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    _selected.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (siblings.length > 1) ...[
                  Gap(20.h),
                  StoreCategoryCircles(
                    selectedIndex: siblings.indexOf(_selected),
                    items: [
                      for (final sub in siblings)
                        StoreCircleItemData(title: sub.title, image: sub.image),
                    ],
                    onTap: (index) => _select(siblings[index]),
                  ),
                ],
                Gap(16.h),
                ProductSortField(
                  value: _sort,
                  onChanged: (sort) => setState(() => _sort = sort),
                ),
                Gap(4.h),
                _buildProducts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProducts() {
    final padding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
    const physics = NeverScrollableScrollPhysics();

    return BlocBuilder<ProductBloc, BaseState<ItemModel>>(
      builder: (context, state) {
        if (state.isLoading || state.isInitial) {
          return CategoryProductGridShimmer(
            padding: padding,
            shrinkWrap: true,
            physics: physics,
          );
        }
        return CategoryProductsGrid(
          padding: padding,
          shrinkWrap: true,
          physics: physics,
          products: _sort.apply(
            state.items.map((item) => item.toProductMap()).toList(),
          ),
        );
      },
    );
  }
}
