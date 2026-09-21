import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.languageCode == 'en';

    return InkWell(
      onTap: () {
        context.setLocale(isEnglish ? const Locale('ar') : const Locale('en'));
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, color: Colors.white, size: 16.sp),

            SizedBox(width: 5.w),

            Text(
              isEnglish ? 'AR' : 'EN',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
