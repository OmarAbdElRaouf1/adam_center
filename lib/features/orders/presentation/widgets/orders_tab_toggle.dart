import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class OrdersTabToggle extends StatelessWidget {
  const OrdersTabToggle({
    super.key,
    required this.showPrevious,
    required this.onChanged,
  });

  final bool showPrevious;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'My Current Orders'.tr(),
              selected: !showPrevious,
              onTap: () => onChanged(false),
            ),
          ),
          Gap(4.w),
          Expanded(
            child: _TabButton(
              label: 'My Previous Orders'.tr(),
              selected: showPrevious,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.chip.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor.withValues(alpha: 0.75)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.chip.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
