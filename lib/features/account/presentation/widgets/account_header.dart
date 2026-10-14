import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

/// Grey avatar circle with the user's name under it (same look as the
/// drawer header).
class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: AppColors.grey.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_rounded, color: Colors.white, size: 60.sp),
        ),
        if (name.isNotEmpty) ...[
          Gap(14.h),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ],
    );
  }
}
