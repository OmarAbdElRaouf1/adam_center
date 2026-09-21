import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_one_test/core/extension/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? highlightColor;
  final BoxShape? shape;

  const CustomShimmerWidget({
    super.key,
    this.height,
    this.shape = BoxShape.rectangle,
    this.width = double.infinity,
    this.highlightColor,
  });

  const CustomShimmerWidget.circular({super.key, this.highlightColor})
    : height = null,
      width = null,
      shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    final baseColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
    final effectiveHighlightColor =
        highlightColor ??
        (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: effectiveHighlightColor,
      child: Container(
        height: height ?? (shape == BoxShape.circle ? 20.w : 50.h),
        width: width ?? (shape == BoxShape.circle ? 20.w : null),
        decoration: BoxDecoration(
          color: baseColor,
          shape: shape!,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
