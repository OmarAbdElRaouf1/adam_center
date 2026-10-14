import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class TextBanner extends StatelessWidget {
  const TextBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 14.sp,
      color: AppColors.codGray,
      fontWeight: FontWeight.w500,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.primaryColor.withValues(alpha: 0.7),
      child: Column(
        children: [
          Text(
            'Worldwide shipping (3-5 business days)'.tr(),
            textAlign: TextAlign.center,
            style: style,
          ),
          Gap(12.h),
          Text(
            'Free delivery within Kuwait in 24 hours'.tr(),
            textAlign: TextAlign.center,
            style: style,
          ),
        ],
      ),
    );
  }
}
