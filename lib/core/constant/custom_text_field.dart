import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final double borderRadius;
  final Color borderColor;
  final Color fillColor;
  final bool enabled;
  final BorderSide? borderSide;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? prefixIconColor;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.textInputType = TextInputType.text,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.onChanged,
    this.textInputAction,
    this.focusNode,
    this.borderRadius = 12.0,
    this.borderColor = AppColors.mainAppColor,
    this.fillColor = AppColors.whiteColor,
    this.enabled = true,
    this.borderSide,
    this.style,
    this.hintStyle,
    this.prefixIconColor,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType,
      obscureText: widget.obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      style:
          widget.style ??
          TextStyle(
            fontSize: 15.sp,
            color: AppColors.secondaryAppColor,
            fontWeight: FontWeight.w500,
          ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle:
            widget.hintStyle ??
            TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
        prefixIcon: widget.prefixIcon != null
            ? Container(
                margin: EdgeInsets.all(12.w),
                child: Icon(
                  widget.prefixIcon,
                  color: widget.prefixIconColor ?? AppColors.mainAppColor,
                  size: 20.sp,
                ),
              )
            : null,
        filled: true,
        fillColor: widget.fillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: widget.borderSide ?? BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide:
              widget.borderSide ??
              BorderSide(color: Colors.grey.shade300, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide:
              widget.borderSide?.copyWith(color: widget.borderColor) ??
              BorderSide(color: widget.borderColor, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        errorStyle: TextStyle(fontSize: 10.sp, color: Colors.red),
      ),
    );
  }
}
