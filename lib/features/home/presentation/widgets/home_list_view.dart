import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view_item.dart';
import 'package:the_one_test/features/product_details/presentation/views/product_details_view.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key, required this.products});

  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.27,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: products.length > 10 ? 10 : products.length,
        separatorBuilder: (_, _) => Gap(14.w),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            key: ValueKey(product['id']),
            width: context.screenWidth * 0.4,
            child: HomeListViewItem(
              product: product,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsView(product: product),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
