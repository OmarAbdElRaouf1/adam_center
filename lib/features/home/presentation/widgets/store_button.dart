import 'package:the_one_test/core/helper/helper.dart';

/// Full-width action button in the store style: soft brand fill (or an
/// outline) with gently rounded corners.
class StoreButton extends StatelessWidget {
  const StoreButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.chip.r),
    );
    final child = isLoading
        ? SizedBox.square(
            dimension: 22.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: outlined ? AppColors.primaryColor : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 10.w),
                Icon(icon, size: 22.sp),
              ],
            ],
          );
    final onTap = isLoading ? null : onPressed;

    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: outlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                side: BorderSide(color: Colors.grey.shade500),
                shape: shape,
              ),
              child: child,
            )
          : FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.75),
                disabledBackgroundColor: AppColors.primaryColor.withValues(
                  alpha: 0.4,
                ),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                shape: shape,
              ),
              child: child,
            ),
    );
  }
}
