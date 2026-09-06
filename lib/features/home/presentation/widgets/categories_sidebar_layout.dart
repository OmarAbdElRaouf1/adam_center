import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, BaseState<ParentCategoryModel>>(
      listener: (context, state) {
        if (state.isSuccess && state.items.isNotEmpty) {
          final selectedIndex = _selectedIndex < state.items.length
              ? _selectedIndex
              : 0;
          _selectParent(state.items[selectedIndex]);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Column(
            children: [
              SizedBox(
                height: context.screenHeight * 0.11,
                width: context.screenWidth,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) => SizedBox(
                    width: context.screenWidth * 0.19,
                    child: const CategoryRailShimmer(),
                  ),
                ),
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
            SizedBox(
              height: context.screenHeight * 0.11,
              width: context.screenWidth,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: parents.length,
                itemBuilder: (context, index) => SizedBox(
                  width: context.screenWidth * 0.19,
                  child: CategoryRailItem(
                    title: parents[index].title,
                    image: parents[index].image,
                    isSelected: index == selectedIndex,
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      _selectParent(parents[index]);
                    },
                  ),
                ),
              ),
            ),
            Gap(30.h),
            Expanded(
              child: BlocBuilder<SubCategoryBloc, BaseState<SubCategoryModel>>(
                builder: (context, subState) {
                  if (subState.isLoading) {
                    return _SubCategoryGridShimmer();
                  }
                  final subCategories = subState.items;
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: subCategories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => const CategoryTileShimmer(),
    );
  }
}
