import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/presentation/widgets/add_to_cart_control.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_toggle_button.dart';

class HomeListItemImage extends StatelessWidget {
  const HomeListItemImage({
    super.key,
    required this.image,
    required this.productId,
    required this.barCode,
    required this.isFavorite,
    this.onTap,
  });

  final String image;
  final int productId;
  final String barCode;
  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Image.network(
                image,
                height: context.screenHeight * 0.12,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return SizedBox(
                    height: context.screenHeight * 0.12,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        Positioned(
          top: 8,
          right: 8,
          child: FavoriteToggleButton(
            productId: productId,
            initialIsFavorite: isFavorite,
          ),
        ),

        Positioned(
          bottom: 2,
          left: 12,
          child: AddToCartControl(productId: productId, barCode: barCode),
        ),
      ],
    );
  }
}
