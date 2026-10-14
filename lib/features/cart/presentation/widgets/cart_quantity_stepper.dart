import 'package:the_one_test/core/helper/helper.dart';

/// Grey pill: remove (a trash can at one unit) · quantity · add.
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
    final iconColor = AppColors.primaryColor.withValues(alpha: 0.7);

    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: Icon(
              quantity <= 1 ? Icons.delete_outline_rounded : Icons.remove,
              size: 20.sp,
              color: iconColor,
            ),
          ),
          SizedBox(
            width: 36.w,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                context.localizeDigits('$quantity'),
                key: ValueKey(quantity),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: Icon(Icons.add, size: 22.sp, color: iconColor),
          ),
        ],
      ),
    );
  }
}
