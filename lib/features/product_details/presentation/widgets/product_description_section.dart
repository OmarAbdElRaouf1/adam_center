import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:see_more/see_more.dart';

import 'package:the_one_test/core/helper/helper.dart';

class ProductDescriptionSection extends StatelessWidget {
  const ProductDescriptionSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),

        Gap(8.h),

        SeeMoreWidget(
          description,

          trimMode: TrimMode.line,
          maxLines: 1,

          textStyle: TextStyle(
            fontSize: 13.sp,
            height: 1.6,
            color: Colors.grey.shade700,
          ),

          expandText: 'View More'.tr(),
          collapseText: 'View Less'.tr(),

          expandButtonBuilder: (context, onTap) {
            return _ToggleText(
              text: 'View More'.tr(),
              icon: Icons.keyboard_arrow_down_rounded,
              onTap: onTap,
            );
          },

          collapseButtonBuilder: (context, onTap) {
            return _ToggleText(
              text: 'View Less'.tr(),
              icon: Icons.keyboard_arrow_up_rounded,
              onTap: onTap,
            );
          },
        ),
      ],
    );
  }
}

class _ToggleText extends StatelessWidget {
  const _ToggleText({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.only(top: 6.h, right: 4.w, left: 4.w, bottom: 2.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),

            Gap(2.w),

            Icon(icon, size: 18.sp, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
