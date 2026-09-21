import 'package:easy_localization/easy_localization.dart';

import '../helper/helper.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    // if (await canLaunchUrl(launchUri)) {
    //   await launchUrl(launchUri);
    // } else {
    //   throw 'Could not launch $launchUri';
    // }
  }

  Future<void> _openWhatsApp(BuildContext context, String phoneNumber) async {
    // Remove leading zero and add country code (Egypt +20)
    final whatsappNumber = phoneNumber.startsWith('0')
        ? '2${phoneNumber.substring(1)}'
        : phoneNumber;

    final Uri whatsappUri = Uri.parse('https://wa.me/$whatsappNumber');

    // if (await canLaunchUrl(whatsappUri)) {
    //   await launchUrl(
    //     whatsappUri,
    //     mode: LaunchMode.externalApplication,
    //   );
    // } else {
    //   throw 'could_not_launch_whatsapp'.tr();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.backgroundColor,
      appBar: CustomAppBar(titleText: 'help'.tr()), // Added localized title
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                size: 100.sp,
                color: AppColors.mainAppColor,
              ),
              SizedBox(height: 25.h),
              Text(
                'support_contact_number'.tr(),
                style: AppTextTheme.headlineMedium.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                '01096561012',
                style: AppTextTheme.headlineMedium.copyWith(
                  color: AppColors.secondaryColor,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),

              // Call Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await _makePhoneCall('01096561012');
                    } catch (e) {
                      if (context.mounted) {
                        context.showTopSnackBar(
                          child: Text('call_failed'.tr()),
                          backgroundColor: AppColors.red,
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.phone, size: 24.sp, color: Colors.white),
                  label: Text(
                    'call_now'.tr(),
                    style: AppTextTheme.body1.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 4,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // WhatsApp Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await _openWhatsApp(context, '01096561012');
                    } catch (e) {
                      if (context.mounted) {
                        context.showTopSnackBar(
                          child: Text('unable_to_open_whatsapp'.tr()),
                          backgroundColor: AppColors.secondaryColor,
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.chat, size: 24.sp, color: Colors.white),
                  label: Text(
                    'contact_via_whatsapp'.tr(),
                    style: AppTextTheme.body1.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // WhatsApp green
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
