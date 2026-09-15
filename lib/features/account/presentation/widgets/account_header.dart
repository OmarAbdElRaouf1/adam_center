import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final contentColor = isDark ? Colors.white : AppColors.primaryColor;

    return Column(
      children: [
        CircleAvatar(
          radius: 44.r,
          backgroundColor: isDark
              ? Colors.white10
              : AppColors.primaryColor.withValues(alpha: 0.1),
          child: Icon(Icons.person, size: 48.sp, color: contentColor),
        ),
        if (name.isNotEmpty) ...[
          Gap(12.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: contentColor,
            ),
          ),
        ],
      ],
    );
  }
}
