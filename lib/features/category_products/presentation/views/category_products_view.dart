import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_product_grid_shimmer.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';

class CategoryProductsView extends StatelessWidget {
  const CategoryProductsView({super.key, required this.subCategory});

  final SubCategoryModel subCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.languageCode),
      appBar: CustomAppBar(titleText: subCategory.title),
      body: BlocProvider(
        create: (context) =>
            getIt<ProductBloc>()
              ..add(GetProductsByCategoryEvent(subCategory.id ?? 0)),
        child: BlocBuilder<ProductBloc, BaseState<ItemModel>>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CategoryProductGridShimmer();
            }
            final products = state.items
                .map((item) => item.toProductMap())
                .toList();

            return CategoryProductsGrid(products: products);
          },
        ),
      ),
    );
  }
}
