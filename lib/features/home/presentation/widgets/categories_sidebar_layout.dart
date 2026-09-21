import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_selection_cubit/category_selection_cubit.dart';
import 'package:the_one_test/features/category_products/presentation/manager/sub_category_bloc/sub_category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/views/category_products_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/categories_grid_view_item.dart';
import 'package:the_one_test/features/home/presentation/widgets/category_rail_item.dart';

class CategoriesSidebarLayout extends StatelessWidget {
  const CategoriesSidebarLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SubCategoryBloc>(),
      child: const _CategoriesSidebarLayoutView(),
    );
  }
}

class _CategoriesSidebarLayoutView extends StatefulWidget {
  const _CategoriesSidebarLayoutView();

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
          if (state.isLoading) {
            return Column(
              children: [
                _RailRow(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < 5; i++) const CategoryRailShimmer(),
                  ],
                ),
                Gap(30.h),
                Expanded(child: _SubCategoryGridShimmer()),
              ],
            );
          }
          final parents = state.items;
          if (parents.isEmpty) {
            return const SizedBox.shrink();
          }
          final selectedIndex = _selectedIndex < parents.length
              ? _selectedIndex
              : 0;

          return Column(
            children: [
              _RailRow(
                children: [
                  for (var index = 0; index < parents.length; index++)
                    CategoryRailItem(
                      title: parents[index].title,
                      image: parents[index].image,
                      isSelected: index == selectedIndex,
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        _selectParent(parents[index]);
                      },
                    ),
                ],
              ),
              Gap(30.h),
              Expanded(
                child:
                    BlocBuilder<SubCategoryBloc, BaseState<SubCategoryModel>>(
                      builder: (context, subState) {
                        if (subState.isLoading) {
                          return _SubCategoryGridShimmer();
                        }
                        final subCategories = subState.items;
                        return GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: subCategories.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 140,
                                crossAxisSpacing: 16.w,
                                mainAxisSpacing: 20.h,
                                childAspectRatio: 0.72,
                              ),
                          itemBuilder: (context, index) {
                            final sub = subCategories[index];
                            return CategoriesListViewItem(
                              title: sub.title,
                              image: sub.image,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoryProductsView(subCategory: sub),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SubCategoryGridShimmer extends StatelessWidget {
  const _SubCategoryGridShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 140,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => const CategoryTileShimmer(),
    );
  }
}

/// Horizontal category rail whose height follows its tallest item — a
/// screen-height fraction overflows on short phones and wastes space on tall
/// ones.
class _RailRow extends StatelessWidget {
  const _RailRow({required this.children, this.physics});

  final List<Widget> children;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final itemWidth = (context.screenWidth * 0.19).clamp(72.0, 110.0);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: physics,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        ),
      ),
    );
  }
}
