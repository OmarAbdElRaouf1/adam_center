import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'payment_method_tile.dart';

enum PaymentMethod { cashOnDelivery, wallet, card, fawry }

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
        PaymentMethodTile(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Mobile Wallet'.tr(),
          selected: selected == PaymentMethod.wallet,
          onTap: () => onSelect(PaymentMethod.wallet),
        ),
        PaymentMethodTile(
          icon: Icons.credit_card,
          label: 'Credit / Debit Card'.tr(),
          selected: selected == PaymentMethod.card,
          onTap: () => onSelect(PaymentMethod.card),
        ),
        PaymentMethodTile(
          icon: Icons.storefront_outlined,
          label: 'Fawry'.tr(),
          selected: selected == PaymentMethod.fawry,
          onTap: () => onSelect(PaymentMethod.fawry),
        ),
      ],
    );
  }
}
