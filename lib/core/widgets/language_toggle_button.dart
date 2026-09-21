import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../constant/app_colors.dart';

class LanguageDropdownSection extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final String? labelText;
  final EdgeInsets? padding;

  const LanguageDropdownSection({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.labelText,
    this.padding,
  });

  String _getLanguageLabel(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return '🇸🇦';
      case 'en':
        return '🇬🇧';
      case 'fr':
        return '🇫🇷';
      default:
        return '🇬🇧';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode;

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.r),
          color:
              backgroundColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.codGray
                  : Colors.grey[50]),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentLang,
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: iconColor ?? AppColors.mainAppColor,
            ),
            dropdownColor:
                backgroundColor ??
                (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.codGray
                    : Colors.white),
            items: [
              DropdownMenuItem(
                value: 'ar',
                child: Row(
                  children: [
                    Text(
                      _getLanguageFlag('ar'),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    Gap(10.w),
                    Text(
                      _getLanguageLabel('ar'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            textColor ??
                            (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87),
                        fontWeight: currentLang == 'ar'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Text(
                      _getLanguageFlag('en'),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    Gap(10.w),
                    Text(
                      _getLanguageLabel('en'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            textColor ??
                            (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87),
                        fontWeight: currentLang == 'en'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'fr',
                child: Row(
                  children: [
                    Text(
                      _getLanguageFlag('fr'),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    Gap(10.w),
                    Text(
                      _getLanguageLabel('fr'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            textColor ??
                            (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87),
                        fontWeight: currentLang == 'fr'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (String? newLang) {
              if (newLang != null && newLang != currentLang) {
                context.setLocale(Locale(newLang));
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen(),) );
              }
            },
          ),
        ),
      ),
    );
  }
}
