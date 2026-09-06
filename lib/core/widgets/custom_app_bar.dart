import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/extension/context_extension.dart';
import 'package:the_one_test/core/theme/app_text_theme.dart';

import '../../../../../../../core/constant/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  final String? icon;

  const CustomAppBar({super.key, required this.titleText, this.icon});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: isDarkMode ? Colors.white : AppColors.mainAppColor,
      ),
      title: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon!,
                  colorFilter: isDarkMode
                      ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : null,
                ),
                Gap(8.w),
                Text(
                  titleText.tr(),
                  style: AppTextTheme.labelMedium.copyWith(
                    color: isDarkMode ? Colors.white : AppColors.primaryColor,
                  ),
                ),
              ],
            )
          : Text(
              titleText.tr(),
              style: AppTextTheme.body1.copyWith(
                color: isDarkMode ? Colors.white : AppColors.primaryColor,
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
