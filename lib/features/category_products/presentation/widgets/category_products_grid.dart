import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_events.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view_item.dart';
import 'package:the_one_test/features/product_details/presentation/views/product_details_view.dart';

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

class CategoryProductsGrid extends StatelessWidget {
  const CategoryProductsGrid({super.key, required this.products});

  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.no_food_outlined,
        message: 'No products yet'.tr(),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
    );
  }
}
