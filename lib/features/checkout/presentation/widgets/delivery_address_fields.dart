import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/auth/presentation/widgets/custom_drop_down.dart';

class DeliveryAddressFields extends StatelessWidget {
  const DeliveryAddressFields({
    super.key,
    required this.selectedArea,
    required this.onAreaChanged,
    required this.streetController,
    required this.houseNumberController,
    required this.fullAddressController,
  });

  final String? selectedArea;
  final ValueChanged<String?> onAreaChanged;
  final TextEditingController streetController;
  final TextEditingController houseNumberController;
  final TextEditingController fullAddressController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          hint: 'Area'.tr(),
          value: selectedArea,
          items: const ['Cairo', 'Giza', 'Alexandria'],
          onChanged: onAreaChanged,
        ),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: 'Street'.tr(),
                controller: streetController,
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
          validator: Validators.validateEmpty,
          borderColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
