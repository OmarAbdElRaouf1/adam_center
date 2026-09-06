import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';

class DeliveryContactFields extends StatelessWidget {
  const DeliveryContactFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          hintText: 'First Name'.tr(),
          prefixIcon: Icons.person,
          controller: firstNameController,
          validator: Validators.firstNameValidator,
          borderColor: AppColors.primaryColor,
        ),
        Gap(16.h),
        CustomTextFormField(
          hintText: 'Last Name'.tr(),
          prefixIcon: Icons.person,
          controller: lastNameController,
          validator: Validators.lastNameValidator,
          borderColor: AppColors.primaryColor,
        ),
        Gap(16.h),
        CustomTextFormField(
          hintText: 'Phone'.tr(),
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          controller: phoneController,
          validator: Validators.phoneNumberValidator,
          borderColor: AppColors.primaryColor,
        ),
        Gap(16.h),
        CustomTextFormField(
          hintText: 'Email (Optional)'.tr(),
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          borderColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
