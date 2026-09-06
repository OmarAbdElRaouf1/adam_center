import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

class DeliveryAddressButton extends StatelessWidget {
  const DeliveryAddressButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(AppRadius.pill.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              const Spacer(),
              Text(
                'Delivery Address'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 15.r,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                child: Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
