import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';

class DiscountCodeField extends StatelessWidget {
  const DiscountCodeField({
    super.key,
    required this.controller,
    required this.onActivate,
  });

  final TextEditingController controller;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            hintText: 'Enter discount code'.tr(),
            controller: controller,
            borderColor: AppColors.primaryColor,
          ),
        ),
        Gap(10.w),
        Material(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill.r),
            onTap: onActivate,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Text(
                'Activate'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
