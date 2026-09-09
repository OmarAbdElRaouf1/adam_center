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
  });

  final TextEditingController? controller;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: 'Search'.tr(),
        hintStyle: TextStyle(
          color: AppColors.primaryColor.withValues(alpha: 0.6),
          fontSize: 15.sp,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.primaryColor,
          size: 22.sp,
        ),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClear,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(
                    AppColors.primaryColor,
                  ),
                ),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: fillColor ?? Colors.grey.withValues(alpha: 0.1),
      ),
    );
  }
}
