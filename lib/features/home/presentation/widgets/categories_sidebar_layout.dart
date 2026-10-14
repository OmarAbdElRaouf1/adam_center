import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_selection_cubit/category_selection_cubit.dart';
import 'package:the_one_test/features/category_products/presentation/manager/sub_category_bloc/sub_category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/views/category_products_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_section_title.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_breadcrumb.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_category_circles.dart';

class CategoriesSidebarLayout extends StatelessWidget {
  const CategoriesSidebarLayout({
    super.key,
    this.topInset = 0,
    this.controller,
  });

  /// Space the floating header covers at the top of the scroll view.
  final double topInset;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SubCategoryBloc>(),
      child: _CategoriesSidebarLayoutView(
        topInset: topInset,
        controller: controller,
      ),
    );
  }
}

class _CategoriesSidebarLayoutView extends StatefulWidget {
  const _CategoriesSidebarLayoutView({required this.topInset, this.controller});

  final double topInset;
  final ScrollController? controller;

  @override
  State<_CategoriesSidebarLayoutView> createState() =>
      _CategoriesSidebarLayoutViewState();
}

class _CategoriesSidebarLayoutViewState
    extends State<_CategoriesSidebarLayoutView> {
  int _selectedIndex = 0;

  void _selectParent(ParentCategoryModel parent) {
    context.read<SubCategoryBloc>().add(GetSubCategoriesEvent(parent.id ?? 0));
  }

  // Picks up a category tapped from Home's preview row (see
  // CategorySelectionCubit's doc comment) — returns the index it resolved
  // to, or null if there's nothing pending / it doesn't match any loaded
  // parent, in which case the caller keeps its own default.
  int? _consumePendingSelection(List<ParentCategoryModel> parents) {
    final pendingId = getIt<CategorySelectionCubit>().state;
    if (pendingId == null) return null;
    getIt<CategorySelectionCubit>().clear();
    final index = parents.indexWhere((p) => p.id == pendingId);
    return index >= 0 ? index : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategorySelectionCubit, int?>(
      bloc: getIt<CategorySelectionCubit>(),
      listenWhen: (_, pendingId) => pendingId != null,
      listener: (context, _) {
        final state = context.read<CategoryBloc>().state;
        if (!state.isSuccess || state.items.isEmpty) {
          return; // Not loaded yet — the CategoryBloc listener below will
          // pick this same pending value up once it is.
        }
        final index = _consumePendingSelection(state.items);
        if (index == null) return;
        setState(() => _selectedIndex = index);
        _selectParent(state.items[index]);
      },
      child: BlocConsumer<CategoryBloc, BaseState<ParentCategoryModel>>(
        listener: (context, state) {
          if (state.isSuccess && state.items.isNotEmpty) {
            final selectedIndex =
                _consumePendingSelection(state.items) ??
                (_selectedIndex < state.items.length ? _selectedIndex : 0);
            if (selectedIndex != _selectedIndex) {
              setState(() => _selectedIndex = selectedIndex);
            }
            _selectParent(state.items[selectedIndex]);
          }
        },
        builder: (context, state) {
          final parents = state.items;
          if (!state.isLoading && parents.isEmpty) {
            return const SizedBox.shrink();
          }
          final selectedIndex = _selectedIndex < parents.length
              ? _selectedIndex
              : 0;
          final title = parents.isEmpty
              ? 'Categories'.tr()
              : parents[selectedIndex].title;

          return CustomScrollView(
            controller: widget.controller,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(widget.topInset + 20.h),
                    StoreBreadcrumb(current: title),
                    Gap(14.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(20.h),
                    StoreCategoryCircles(
                      isLoading: state.isLoading,
                      selectedIndex: selectedIndex,
                      items: [
                        for (final parent in parents)
                          StoreCircleItemData(
                            title: parent.title,
                            image: parent.image,
                          ),
                      ],
                      onTap: (index) {
                        setState(() => _selectedIndex = index);
                        _selectParent(parents[index]);
                      },
                    ),
                    Gap(12.h),
                    if (!state.isLoading)
                      HomeSectionTitle(title: 'Subcategories'.tr()),
                    Gap(20.h),
                  ],
                ),
              ),
              if (state.isLoading)
                const _SubCategoryGridShimmer()
              else
                BlocBuilder<SubCategoryBloc, BaseState<SubCategoryModel>>(
                  builder: (context, subState) {
                    if (subState.isLoading) {
                      return const _SubCategoryGridShimmer();
                    }
                    final subCategories = subState.items;
                    return _SubCategoryGrid(
                      itemCount: subCategories.length,
                      itemBuilder: (context, index, size) {
                        final sub = subCategories[index];
                        return StoreCategoryCircle(
                          size: size,
                          data: StoreCircleItemData(
                            title: sub.title,
                            image: sub.image,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryProductsView(
                                subCategory: sub,
                                siblings: subCategories,
                                parentTitle: parents[selectedIndex].title,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              SliverToBoxAdapter(
                child: Gap(MediaQuery.paddingOf(context).bottom + 40.h),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Three-column sliver grid of round subcategory tiles.
class _SubCategoryGrid extends StatelessWidget {
  const _SubCategoryGrid({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget Function(BuildContext context, int index, double size)
  itemBuilder;

  @override
  Widget build(BuildContext context) {
    final size = (context.screenWidth - 40.w - 2 * 16.w) / 3 - 8.w;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverGrid.builder(
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          mainAxisExtent: size + 44.h,
        ),
        itemBuilder: (context, index) => itemBuilder(context, index, size),
      ),
    );
  }
}

class _SubCategoryGridShimmer extends StatelessWidget {
  const _SubCategoryGridShimmer();

  @override
  Widget build(BuildContext context) {
    return _SubCategoryGrid(
      itemCount: 9,
      itemBuilder: (context, index, size) => Align(
        alignment: Alignment.topCenter,
        child: BlockShimmer(
          width: size,
          height: size,
          borderRadius: BorderRadius.circular(size),
        ),
      ),
    );
  }
}
