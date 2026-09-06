import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/orders/data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.status.label.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: order.status.color,
                ),
              ),
              Text(
                '${'Order Number'.tr()} ${context.localizeDigits(order.orderNumber)}',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            '${'Order Date'.tr()} ${context.localizeDigits(order.date)}',
            style: TextStyle(
              fontSize: 12.sp,
              color: onSurface,
            ),
          ),
          Gap(10.h),
          Text(
            'Delivery Address'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),
          Gap(4.h),
          Text(
            context.localizeDigits(order.address),
            style: TextStyle(fontSize: 13.5.sp, height: 1.5),
          ),
          Gap(10.h),
          Divider(height: 1, color: Theme.of(context).dividerTheme.color),
          Gap(10.h),
          Text(
            context.localizeDigits(
              '${'Total Price'.tr()}: ${order.totalPrice.toStringAsFixed(2)} ${'EGP'.tr()}',
            ),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
