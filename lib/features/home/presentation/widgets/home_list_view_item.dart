import 'package:the_one_test/core/helper/helper.dart';

import 'home_list_item_details.dart';
import 'home_list_item_image.dart';

class HomeListViewItem extends StatelessWidget {
  const HomeListViewItem({super.key, required this.product, this.onTap});

  final Map<String, String> product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeListItemImage(
              image: product['image']!,
              productId: int.tryParse(product['id'] ?? '') ?? 0,
              barCode: product['barCode'] ?? '',
              isFavorite: product['isFavorite'] == 'true',
              onTap: onTap,
            ),
            HomeListItemDetails(
              price: product['price']!,
              name: product['name']!,
              description: product['description']!,
            ),
          ],
        ),
      ),
    );
  }
}
