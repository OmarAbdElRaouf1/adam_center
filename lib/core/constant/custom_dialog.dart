import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'app_colors.dart';

void customDialog({
  required BuildContext context,
  required String title,
  String subTitle = '',
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie.asset(
              //   AppAssets.error,
              //   width: 150,
              //   height: 150,
              //   repeat: false,
              // ),
              Gap(5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mainAppColor,
                  fontFamily: "Hacen",
                ),
                textAlign: TextAlign.center,
              ),
              Gap(8.h),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Hacen",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.hitColor,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future.delayed(const Duration(seconds: 4), () {
    Navigator.of(context).pop();
  });
}
