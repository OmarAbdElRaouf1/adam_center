import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';

class CartEmpty extends StatelessWidget {
  const CartEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 90.h, 28.w, 0),
      child: Column(
        children: [
          Text(
            'Your cart is empty'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor.withValues(alpha: 0.75),
            ),
          ),
          Gap(20.h),
          Text(
            'Add what you want to buy to the cart to see it here and complete your purchase'
                .tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
          Gap(24.h),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: SizedBox(
              height: 50.h,
              child: FilledButton(
                onPressed: () => popToStoreRoot(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.75,
                  ),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.chip.r),
                  ),
                ),
                child: Text(
                  'Start Shopping Now'.tr(),
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
