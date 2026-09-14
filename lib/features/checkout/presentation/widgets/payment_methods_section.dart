import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'payment_method_tile.dart';

enum PaymentMethod { cashOnDelivery }

class PaymentMethodsSection extends StatelessWidget {
  const PaymentMethodsSection({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method'.tr(),
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        Gap(6.h),
        PaymentMethodTile(
          icon: Icons.payments_outlined,
          label: 'Cash on Delivery'.tr(),
          selected: selected == PaymentMethod.cashOnDelivery,
          onTap: () => onSelect(PaymentMethod.cashOnDelivery),
        ),
      ],
    );
  }
}
