import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_events.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view_item.dart';

import '../views/product_details_view.dart';

void _addToCart(BuildContext context, Map<String, String> product) {
  final user = getIt<UserSessionCache>().getUser();
  context.read<AddToCartBloc>().add(
    AddToCart(
      AddToCartRequest(
        customerID: user?.customerId ?? 0,
        productID: int.tryParse(product['id'] ?? '') ?? 0,
        productBarcode: product['barCode'] ?? '',
      ),
    ),
  );
}

class SimilarProductsSection extends StatelessWidget {
  const SimilarProductsSection({
    super.key,
    required this.excludeName,
    required this.categoryId,
  });

  final String excludeName;
  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    if (categoryId == null) return const SizedBox.shrink();

    return BlocProvider(
      create: (context) =>
          getIt<ProductBloc>()..add(GetProductsByCategoryEvent(categoryId!)),
      child: BlocBuilder<ProductBloc, BaseState<ItemModel>>(
        builder: (context, state) {
          if (state.isLoading) {
            return const ProductGridShimmer(itemCount: 4);
          }

          final items = state.items
              .where((item) => item.productArName != excludeName)
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

          if (items.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Similar Products'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Gap(12.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final product = items[index];
                  return HomeListViewItem(
                    product: product,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsView(product: product),
                      ),
                    ),
                    onAddTap: () => _addToCart(context, product),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
