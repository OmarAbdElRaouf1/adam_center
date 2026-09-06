import 'package:the_one_test/core/helper/helper.dart';

import 'home_list_item_details.dart';
import 'home_list_item_image.dart';

class HomeListViewItem extends StatelessWidget {
  const HomeListViewItem({
    super.key,
    required this.product,
    this.onAddTap,
    this.onTap,
  });

  final Map<String, String> product;
  final VoidCallback? onAddTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            isFavorite: product['isFavorite'] == 'true',
            onAddTap: onAddTap,
            onTap: onTap,
          ),
          HomeListItemDetails(
            price: product['price']!,
            name: product['name']!,
            description: product['description']!,
          ),
        ],
      ),
    );
  }
}
