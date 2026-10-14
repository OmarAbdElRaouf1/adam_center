import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';

/// "Home › Current page" trail; tapping Home pops back to the root.
class StoreBreadcrumb extends StatelessWidget {
  const StoreBreadcrumb({super.key, this.current});

  final String? current;

  @override
  Widget build(BuildContext context) {
    final chevron = Icon(
      context.isArabic
          ? Icons.chevron_left_rounded
          : Icons.chevron_right_rounded,
      size: 18.sp,
      color: Colors.grey,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => popToStoreRoot(context),
            child: Text(
              'Home'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.primaryColor.withValues(alpha: 0.7),
              ),
            ),
          ),
          Gap(6.w),
          chevron,
          if (current != null) ...[
            Gap(6.w),
            Flexible(
              child: Text(
                current!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
