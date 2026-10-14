import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'price_row.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  final double subtotal;
  final double deliveryFee;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PriceRow(label: 'Subtotal'.tr(), value: subtotal),
        PriceRow(label: 'Delivery Fees'.tr(), value: deliveryFee),
        Gap(10.h),
        PriceRow(label: 'Total'.tr(), value: total, emphasized: true),
      ],
    );
  }
}
