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
    return TextField(
      controller: controller,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,

      style: TextStyle(fontSize: 13.sp),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search'.tr(),
        hintStyle: TextStyle(
          color: AppColors.primaryColor.withValues(alpha: 0.6),
          fontSize: 13.sp,
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 36.w, minHeight: 18.sp),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.primaryColor,
          size: 18.sp,
        ),
        suffixIconConstraints: BoxConstraints(minWidth: 32.w, minHeight: 18.sp),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: Icon(Icons.close, size: 16.sp),
                padding: EdgeInsets.zero,
                onPressed: onClear,
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  minimumSize: Size(32.w, 32.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            : suffix,
        contentPadding: EdgeInsets.symmetric(vertical: 6.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.badge.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: fillColor ?? Colors.grey.withValues(alpha: 0.1),
      ),
    );
  }
}
