import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class CartQuantityStepper extends StatelessWidget {
  const CartQuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.add,
          background: AppColors.primaryColor,
          iconColor: Colors.white,
          onTap: onIncrement,
        ),
        Gap(8.w),
        Text(
          context.localizeDigits('$quantity'),
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        Gap(8.w),
        _StepperButton(
          icon: Icons.remove,
          background: Colors.grey.shade200,
          iconColor: Colors.grey.shade600,
          onTap: onDecrement,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(icon, size: 16.sp, color: iconColor),
        ),
      ),
    );
  }
}
