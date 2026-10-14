import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({
    super.key,
    required this.title,
    this.padding,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final EdgeInsetsGeometry? padding;

  /// Optional underlined link after the line (e.g. "View all").
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          Gap(16.w),
          Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.primaryColor.withValues(alpha: 0.25),
            ),
          ),
          if (actionLabel != null) ...[
            Gap(16.w),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.primaryColor.withValues(alpha: 0.75),
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryColor.withValues(
                    alpha: 0.75,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
