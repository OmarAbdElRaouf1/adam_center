import 'package:easy_localization/easy_localization.dart';
import '../../../../core/helper/helper.dart';

class ProductPriceSection extends StatelessWidget {
  final double price;
  final double priceAfterDiscount;
  final bool hasDiscount;
  final double? customerQuantity;

  const ProductPriceSection({
    super.key,
    required this.price,
    required this.priceAfterDiscount,
    required this.hasDiscount,
    this.customerQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final currency = 'EGP'.tr();

    final hasLimit = customerQuantity != null && customerQuantity! > 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${priceAfterDiscount.toStringAsFixed(2)} $currency',
              style: AppTextTheme.bodyMedium.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.mainAppColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasDiscount && !hasLimit) ...[
              const SizedBox(width: 4),
              Text(
                'instead_of'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.labelSmall9Bold,
              ),
              const SizedBox(width: 4),
              Text(
                '${price.toStringAsFixed(2)} $currency',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.captionBold.copyWith(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
            if (hasLimit && hasDiscount) ...[
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppColors.mainAppColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${'limit'.tr()} ${customerQuantity!.toInt()}',
                  style: AppTextTheme.labelSmall9Bold.copyWith(
                    color: AppColors.mainAppColor,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (hasLimit && hasDiscount)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${'after_limit_price'.tr()}: ',
                  style: AppTextTheme.labelSmall9Bold.copyWith(fontSize: 10.sp),
                ),
                Text(
                  '${price.toStringAsFixed(2)} $currency',
                  style: AppTextTheme.captionBold.copyWith(
                    color: Colors.grey,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
