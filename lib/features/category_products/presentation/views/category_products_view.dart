import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';

class CategoryProductsView extends StatelessWidget {
  const CategoryProductsView({super.key, required this.subCategory});

  final SubCategoryModel subCategory;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddToCartBloc>(create: (_) => getIt<AddToCartBloc>()),
        BlocProvider<FavoriteBloc>(create: (_) => getIt<FavoriteBloc>()),
      ],
      child: BlocListener<AddToCartBloc, BaseState<void>>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.showSuccessMessage('Added to Cart'.tr());
          } else if (state.isFailure) {
            context.showErrorMessage(state.errorMessage ?? '');
          }
        },
        child: Scaffold(
          key: ValueKey(context.locale.languageCode),
          appBar: CustomAppBar(titleText: subCategory.title),
          body: BlocProvider(
            create: (context) =>
                getIt<ProductBloc>()
                  ..add(GetProductsByCategoryEvent(subCategory.id ?? 0)),
            child: BlocBuilder<ProductBloc, BaseState<ItemModel>>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const ProductGridShimmer();
                }
                final products = state.items
                    .map(
                      (item) => {
                        'id': item.productId.toString(),
                        'barCode': item.barCode,
                        'isFavorite': item.isFavorite.toString(),
                        'image': item.productImage ?? '',
                        'name': item.productArName,
                        'description': item.description1 ?? '',
                        'price': item.price.toString(),
                        'categoryId': item.categoryId ?? '',
                      },
                    )
                    .toList();

                return CategoryProductsGrid(products: products);
              },
            ),
          ),
        ),
      ),
    );
  }
}
