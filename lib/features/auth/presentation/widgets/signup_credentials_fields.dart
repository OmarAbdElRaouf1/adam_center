import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';

class SignupCredentialsFields extends StatelessWidget {
  const SignupCredentialsFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          keyboardType: TextInputType.phone,
          validator: Validators.phoneNumberValidator,
          controller: phoneController,
          borderColor: AppColors.primaryColor,
        ),

        Gap(16.h),

        CustomTextFormField(
          hintText: 'Email'.tr(),
          prefixIcon: Icons.email,
          controller: emailController,
          validator: Validators.emailValidator,
          borderColor: AppColors.primaryColor,
        ),

        Gap(16.h),

        PasswordTextFormField(
          controller: passwordController,
          hintText: 'Password'.tr(),
          validator: Validators.passwordValidator,
          borderColor: AppColors.primaryColor,
        ),
        Gap(16.h),

        PasswordTextFormField(
          controller: confirmPasswordController,
          hintText: 'Confirm Password'.tr(),
          validator: (value) => Validators.repeatPasswordValidator(
            value: value,
            Password: passwordController.text,
          ),
          borderColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
