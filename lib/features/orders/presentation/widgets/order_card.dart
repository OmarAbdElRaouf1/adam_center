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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'Order Number'.tr()} ${context.localizeDigits(order.orderNumber)}',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: order.status.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill.r),
                ),
                child: Text(
                  order.status.label.tr(),
                  style: TextStyle(fontSize: 12.sp, color: order.status.color),
                ),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            '${'Order Date'.tr()} ${context.localizeDigits(order.date)}',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
          ),
          if (order.items.isNotEmpty) ...[
            Gap(10.h),
            Text(
              'Order Items'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
            ),
            Gap(4.h),
            for (final item in order.items)
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        context.localizeDigits(_itemName(context, item)),
                        style: TextStyle(fontSize: 13.5.sp, height: 1.5),
                      ),
                    ),
                    Gap(8.w),
                    Text(
                      context.localizeDigits(
                        '${'Quantity'.tr()}: ${_formatQuantity(item.quantity)}',
                      ),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.primaryColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
          ],
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
          Divider(height: 1, color: Colors.grey.shade200),
          Gap(10.h),
          Text(
            context.localizeDigits(
              '${'Total Price'.tr()}: ${order.totalPrice.toStringAsFixed(2)} ${'EGP'.tr()}',
            ),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  String _itemName(BuildContext context, OrderItemModel item) {
    final preferred = context.isArabic ? item.arName : item.enName;
    return preferred.isNotEmpty ? preferred : item.arName;
  }

  String _formatQuantity(num quantity) => quantity == quantity.truncate()
      ? quantity.toInt().toString()
      : quantity.toString();
}
