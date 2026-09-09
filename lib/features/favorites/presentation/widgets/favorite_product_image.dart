import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/presentation/widgets/add_to_cart_control.dart';

import 'favorite_toggle_button.dart';

class FavoriteProductImage extends StatelessWidget {
  const FavoriteProductImage({
    super.key,
    required this.image,
    required this.productId,
    required this.barCode,
  });

  final String image;
  final int productId;
  final String barCode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Image.network(
            image,
            width: 90.w,
            height: 90.w,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 90.w,
              height: 90.w,
              color: Colors.grey.shade100,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: FavoriteToggleButton(
            productId: productId,
            initialIsFavorite: true,
            size: 18,
          ),
        ),
        PositionedDirectional(
          bottom: -8,
          start: -8,
          child: AddToCartControl(
            productId: productId,
            barCode: barCode,
            size: 30.w,
          ),
        ),
      ],
    );
  }
}
