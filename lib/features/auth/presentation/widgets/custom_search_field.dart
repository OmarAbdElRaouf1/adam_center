import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.controller,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onClear,
    this.fillColor,
    this.suffix,
  });

  final TextEditingController? controller;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Color? fillColor;

  /// Shown at the end of the field while it is empty.
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(double alpha, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.badge.r),
      borderSide: BorderSide(
        color: AppColors.primaryColor.withValues(alpha: alpha),
        width: width,
      ),
    );

    return TextField(
      controller: controller,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      cursorColor: AppColors.primaryColor,
      style: TextStyle(fontSize: 15.sp),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search for products'.tr(),
        hintStyle: TextStyle(
          color: AppColors.primaryColor.withValues(alpha: 0.85),
          fontSize: 15.sp,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 44.w, minHeight: 24.sp),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.primaryColor,
          size: 24.sp,
        ),
        suffixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 24.sp),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: Icon(Icons.close, size: 20.sp),
                padding: EdgeInsets.zero,
                onPressed: onClear,
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  minimumSize: Size(40.w, 40.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            : suffix,
        contentPadding: EdgeInsets.symmetric(vertical: 13.h),
        border: border(0.55, 1.2),
        enabledBorder: border(0.55, 1.2),
        focusedBorder: border(1, 1.8),
        filled: true,
        fillColor: fillColor ?? AppColors.primaryColor.withValues(alpha: 0.08),
      ),
    );
  }
}
