import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_logo.dart';

/// Top of every auth screen: the store logo and the title (+ optional
/// subtitle).
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.topRow,
  });

  final String title;
  final String? subtitle;
  final Widget? topRow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ?topRow,
        Gap(16.h),
        StoreLogo(size: 130.w),
        Gap(24.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor.withValues(alpha: 0.75),
          ),
        ),
        if (subtitle != null) ...[
          Gap(8.h),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700),
          ),
        ],
      ],
    );
  }
}
