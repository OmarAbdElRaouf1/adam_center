import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class HomeListItemDetails extends StatelessWidget {
  const HomeListItemDetails({
    super.key,
    required this.price,
    required this.priceAfterDiscount,
    required this.quantity,
    required this.name,
    this.categoryArName = '',
    this.categoryEnName = '',
    required this.description,
  });

  final String price;
  final String priceAfterDiscount;
  final String quantity;
  final String name;
  final String categoryArName;
  final String categoryEnName;
  final String description;

  @override
  Widget build(BuildContext context) {
    final originalPrice = double.tryParse(price) ?? 0;
    final discountedPrice = double.tryParse(priceAfterDiscount) ?? 0;
    final hasDiscount = discountedPrice > 0 && discountedPrice < originalPrice;
    final isInStock = (int.tryParse(quantity) ?? 0) > 0;
    final categoryName = context.isArabic
        ? categoryArName
        : (categoryEnName.isNotEmpty ? categoryEnName : categoryArName);

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0.h, 14.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (categoryName.isNotEmpty) ...[
            Text(
              categoryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor.withValues(alpha: 0.8),
              ),
            ),
            Gap(2.h),
          ],
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Gap(6.h),

          if (hasDiscount) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${context.localizeDigits(discountedPrice.toStringAsFixed(0))} ${'EGP'.tr()}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Gap(6.w),
                Text(
                  context.localizeDigits(originalPrice.toStringAsFixed(0)),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            Gap(4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
              ),
              child: Text(
                '${'Save'.tr()} ${context.localizeDigits((originalPrice - discountedPrice).toStringAsFixed(0))} ${'EGP'.tr()}',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.red,
                ),
              ),
            ),
          ] else
            Text(
              '${context.localizeDigits(originalPrice.toStringAsFixed(0))} ${'EGP'.tr()}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

          Gap(6.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: (isInStock ? Colors.green : AppColors.red).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
            ),
            child: Text(
              isInStock ? 'In Stock'.tr() : 'Out of Stock'.tr(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isInStock ? Colors.green.shade700 : AppColors.red,
              ),
            ),
          ),

          Gap(4.h),

          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
