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
    required this.stockQuantity,
    this.discountPercentage,
    this.onTap,
  });

  final String image;
  final int productId;
  final String barCode;
  final bool isFavorite;
  final int stockQuantity;
  final int? discountPercentage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(12.w),
          child: GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card.r),
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

        if (discountPercentage != null && discountPercentage! > 0)
          Positioned(
            top: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red.withValues(alpha: 0.35),
                    blurRadius: 6.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Text(
                '${context.localizeDigits('$discountPercentage')}%-',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        Positioned(
          top: 8.h,
          right: 8.w,
          child: FavoriteToggleButton(
            productId: productId,
            initialIsFavorite: isFavorite,
          ),
        ),

        Positioned(
          bottom: 2.h,
          left: 12.w,
          child: AddToCartControl(
            productId: productId,
            barCode: barCode,
            stockQuantity: stockQuantity,
          ),
        ),
      ],
    );
  }
}
