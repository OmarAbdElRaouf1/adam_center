import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final double value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: emphasized ? 22.sp : 16.sp,
      fontWeight: emphasized ? FontWeight.w600 : FontWeight.w400,
      color: emphasized ? AppColors.primaryColor.withValues(alpha: 0.85) : null,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            context.localizeDigits('${value.toStringAsFixed(2)} ${'EGP'.tr()}'),
            style: style,
          ),
        ],
      ),
    );
  }
}
