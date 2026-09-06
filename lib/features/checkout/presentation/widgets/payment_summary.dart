import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'price_row.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.discountRate,
    required this.discountValue,
    required this.total,
  });

  final double subtotal;
  final double deliveryFee;
  final double discountRate;
  final double discountValue;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Theme.of(context).dividerTheme.color),
        Gap(10.h),
        PriceRow(label: 'Subtotal'.tr(), value: subtotal),
        PriceRow(label: 'Delivery Fees'.tr(), value: deliveryFee),
        PriceRow(
          label: discountRate > 0
              ? '${'Discount'.tr()} (${(discountRate * 100).toStringAsFixed(0)}%)'
              : 'Discount'.tr(),
          value: discountValue,
        ),
        Gap(10.h),
        Divider(color: Theme.of(context).dividerTheme.color),
        Gap(10.h),
        PriceRow(label: 'Total'.tr(), value: total, emphasized: true),
      ],
    );
  }
}
