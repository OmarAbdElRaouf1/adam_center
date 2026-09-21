import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScannerInstructionsBanner extends StatelessWidget {
  const ScannerInstructionsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.paddingOf(context).bottom + 24,
      left: 20.w,
      right: 20.w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white, size: 40.sp),
            SizedBox(height: 12.h),
            Text(
              'Point your camera at a barcode'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
