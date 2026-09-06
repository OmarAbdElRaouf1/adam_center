import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';

class DeliveryAddressFields extends StatelessWidget {
  const DeliveryAddressFields({
    super.key,
    required this.areaController,
    required this.streetController,
    required this.houseNumberController,
    required this.fullAddressController,
  });

  final TextEditingController areaController;
  final TextEditingController streetController;
  final TextEditingController houseNumberController;
  final TextEditingController fullAddressController;

  @override
  Widget build(BuildContext context) {
    // These all come from the address picked via the "Delivery Address"
    // button (a real saved address) — editing them free-form here wouldn't
    // update that saved address, it'd just create a mismatch between what's
    // shown and what's actually stored. Changing the address only happens
    // through the picker.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          hintText: 'Area'.tr(),
          controller: areaController,
          readOnly: true,
          validator: Validators.validateEmpty,
          borderColor: AppColors.primaryColor,
        ),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: 'Street'.tr(),
                controller: streetController,
                readOnly: true,
                validator: Validators.validateEmpty,
                borderColor: AppColors.primaryColor,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: CustomTextFormField(
                hintText: 'House Number'.tr(),
                keyboardType: TextInputType.number,
                controller: houseNumberController,
                readOnly: true,
                validator: Validators.validateEmpty,
                borderColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        Gap(16.h),
        CustomTextFormField(
          hintText: 'Full Address'.tr(),
          controller: fullAddressController,
          maxLines: 4,
          readOnly: true,
          validator: Validators.validateEmpty,
          borderColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
