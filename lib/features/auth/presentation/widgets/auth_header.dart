import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

/// The icon-circle + title (+ optional subtitle) block shown at the top of
/// every auth screen, sitting on the primary-color hero background.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.topRow,
    this.iconSize = 32,
    this.titleFontSize = 26,
    this.iconBoxRadius = 20,
    this.iconBoxBordered = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? topRow;
  final double iconSize;
  final double titleFontSize;
  final double iconBoxRadius;
  final bool iconBoxBordered;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ?topRow,
        Gap(12.h),
        Container(
          width: context.screenWidth * 0.15,
          height: context.screenWidth * 0.15,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: iconBoxBordered ? 0.15 : 0.2),
            borderRadius: BorderRadius.circular(iconBoxRadius),
            border: iconBoxBordered
                ? Border.all(color: Colors.white.withValues(alpha: 0.2))
                : null,
          ),
          child: Icon(icon, color: Colors.white, size: iconSize.sp),
        ),
        Gap(16.h),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...[
          Gap(8.h),
          Text(
            subtitle!,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 14.sp,
            ),
          ),
        ],
      ],
    );
  }
}
