import 'package:flutter/material.dart';

import '../theme/app_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.sized = 2,
    this.labelSize = 11,
    this.color = const Color(0xff044E0F),
  });

  final String label;
  final String value;
  final double sized;
  final double labelSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label,
              style: AppTextTheme.labelMedium11.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: labelSize.sp,
              ),
            ),
            WidgetSpan(child: SizedBox(width: sized.w)),
            TextSpan(
              text: value,
              style: AppTextTheme.labelMedium11.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
