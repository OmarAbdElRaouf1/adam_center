import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppShadows {
  static List<BoxShadow> card(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.32 : 0.06),
        blurRadius: 16.r,
        offset: Offset(0, 6.h),
      ),
    ];
  }

  static List<BoxShadow> raised(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
        blurRadius: 20.r,
        offset: Offset(0, 8.h),
      ),
    ];
  }
}
