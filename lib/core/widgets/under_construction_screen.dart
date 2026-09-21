import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../extension/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnderConstructionScreen extends StatefulWidget {
  const UnderConstructionScreen({super.key, this.title});

  final String? title;

  @override
  State<UnderConstructionScreen> createState() =>
      _UnderConstructionScreenState();
}

class _UnderConstructionScreenState extends State<UnderConstructionScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title ?? "under_construction_title".tr()),
        centerTitle: true,
        backgroundColor: isDark ? AppColors.codGray : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : AppColors.mainAppColor,
        ),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 900),
          opacity: _opacity,
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutBack,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.construction_rounded,
                    size: 72.sp,
                    color: AppColors.mainAppColor,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "under_construction_message".tr(),
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  "under_construction_subtitle".tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? Colors.white70 : Colors.black54,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainAppColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp),
                  label: Text("back".tr(), style: TextStyle(fontSize: 18.sp)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
