import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/presentation/widgets/add_to_cart_control.dart';

class ProductUnitCard extends StatelessWidget {
  const ProductUnitCard({
    super.key,
    required this.productId,
    required this.barCode,
    required this.code,
    required this.price,
    required this.quantity,
  });

  final int productId;
  final String barCode;
  final String code;
  final String price;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        boxShadow: AppShadows.card(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'Code'.tr()}: ${context.localizeDigits(code)}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                Gap(6.h),
                Row(
                  children: [
                    Text(
                      context.localizeDigits(price),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Gap(4.w),
                    Text(
                      'EGP'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Gap(4.w),
                    Text(
                      'Per Unit'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Gap(6.h),
                Text(
                  '${'Quantity'.tr()}: ${context.localizeDigits(quantity)}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),

          AddToCartControl(productId: productId, barCode: barCode, size: 36),
        ],
      ),
    );
  }
}
