import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
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

class HomeListView extends StatelessWidget {
  const HomeListView({super.key, required this.products});

  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.25,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: products.length > 10 ? 10 : products.length,
        separatorBuilder: (_, _) => Gap(14.w),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: context.screenWidth * 0.4,
            child: HomeListViewItem(
              product: product,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsView(product: product),
                ),
              ),
              onAddTap: () => _addToCart(context, product),
            ),
          );
        },
      ),
    );
  }
}
