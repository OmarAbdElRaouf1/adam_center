import 'package:flutter/material.dart';
import '../constant/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomSnackBar(
  BuildContext context,
  String text, {
  IconData icon = Icons.check_circle,
  Color iconColor = Colors.green,
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  if (context.mounted) {
    // Cancels any snackbar mid-flight with no exit animation, so rapid taps
    // don't queue up snackbars behind each other (which looks like it never
    // dismisses) — this differs from hideCurrentSnackBar(), whose animated
    // exit can race with the next snackbar's entrance and get stuck.
    scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      snackBarAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 350),
        reverseDuration: const Duration(milliseconds: 250),
      ),
      SnackBar(
        content: Row(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 450),
              curve: Curves.elasticOut,
              builder: (context, value, child) =>
                  Transform.scale(scale: value, child: child),
              child: Icon(icon, color: iconColor, size: 22.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset((1 - value) * 12, 0),
                    child: child,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF232F3E),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        // SnackBar.persist defaults to true whenever an action is set, which
        // disables the auto-dismiss timer entirely — force it off so this
        // always times out on its own, action or not.
        persist: false,
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: iconColor,
                onPressed: onActionPressed ?? () {},
              ),
      ),
    );
  }
}
