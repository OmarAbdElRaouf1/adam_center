import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  /// The controller for the text field.
  final TextEditingController? controller;

  /// The hint text to display as placeholder.
  final String? hintText;

  /// Optional suffix icon, e.g., Icons.edit for a pencil icon.
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final Function()? onPrefixIconPressed;
  final Function()? onSuffixIconPressed;

  /// Callback when the text changes.
  final Function(String)? onChanged;

  /// Validator function for form validation.
  final String? Function(String?)? validator;

  /// Optional keyboard type, defaults to TextInputType.text.
  final TextInputType keyboardType;

  /// Border radius, defaults to 9 to match SVG's 8.5 (approximated).
  final double borderRadius;

  /// Border color, defaults to #15304E.
  final Color? borderColor;

  /// Prefix icon color, defaults to [borderColor].
  final Color? prefixIconColor;

  /// Background color, defaults to white.
  final Color? backgroundColor;

  final bool obscureText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;

  final Function()? onTap;
  final bool? readOnly;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Widget? suffixWidget;
  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.borderRadius = 9.0,
    this.borderColor,
    this.prefixIconColor,
    this.backgroundColor,
    this.obscureText = false,
    this.onPrefixIconPressed,
    this.onSuffixIconPressed,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
    this.maxLines,
    this.minLines,
    this.onTap,
    this.readOnly,
    this.focusNode,
    this.onFieldSubmitted,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 50,
      child: TextFormField(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),

        autocorrect: true,
        controller: controller,
        onTap: onTap,
        readOnly: readOnly ?? false,
        focusNode: focusNode,
        onChanged: onChanged,
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          hintText: hintText,

          // hintStyle: AppTextTheme.caption,
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
          labelStyle: TextStyle(color: Colors.red, fontSize: 12),

          prefixIcon: prefixIcon != null
              ? IconButton(
                  onPressed: onPrefixIconPressed,
                  icon: Icon(
                    prefixIcon,
                    color: prefixIconColor ?? borderColor,
                    size: 18,
                  ),
                )
              : null,
          suffixIcon:
              suffixWidget ??
              (suffixIcon != null
                  ? IconButton(
                      onPressed: onSuffixIconPressed,
                      icon: Icon(suffixIcon, color: borderColor),
                    )
                  : null),
          filled: true,
          fillColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor ?? Color(0xFF15304E),
              width: 0.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor ?? Color(0xFF15304E),
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor ?? Color(0xFF15304E),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
      ),
    );
  }
}

class PasswordTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double borderRadius;
  final Color? borderColor;

  const PasswordTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
    this.borderRadius = 9.0,
    this.borderColor,
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      hintText: widget.hintText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      suffixIcon: _obscureText ? Icons.visibility_off : Icons.visibility,
      prefixIcon: Icons.lock,
      onSuffixIconPressed: () {
        setState(() => _obscureText = !_obscureText);
      },
      borderRadius: widget.borderRadius,
      borderColor: widget.borderColor ?? Color(0xFF15304E),
      keyboardType: TextInputType.visiblePassword,
      maxLines: 1,
    );
  }
}
