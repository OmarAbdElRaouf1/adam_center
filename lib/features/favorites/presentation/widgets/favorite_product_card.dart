import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'favorite_product_image.dart';
import 'favorite_product_info.dart';

class FavoriteProductCard extends StatelessWidget {
  const FavoriteProductCard({
    super.key,
    required this.product,
    this.onDetailsTap,
  });

  final Map<String, String> product;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        boxShadow: AppShadows.card(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FavoriteProductInfo(
              name: product['name']!,
              price: product['price']!,
              onDetailsTap: onDetailsTap,
            ),
          ),
          Gap(10.w),
          FavoriteProductImage(
            image: product['image']!,
            productId: int.tryParse(product['id'] ?? '') ?? 0,
            barCode: product['barCode'] ?? '',
            stockQuantity: int.tryParse(product['quantity'] ?? '') ?? 0,
          ),
        ],
      ),
    );
  }
}
