import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';

class ChangePasswordFields extends StatelessWidget {
  const ChangePasswordFields({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PasswordTextFormField(
          controller: oldPasswordController,
          hintText: 'Old Password'.tr(),
          validator: Validators.passwordValidator,
          borderColor: AppColors.primaryColor,
        ),
        Gap(16.h),
        PasswordTextFormField(
          controller: newPasswordController,
          hintText: 'New Password'.tr(),
          validator: Validators.passwordValidator,
          borderColor: AppColors.primaryColor,
        ),
        Gap(16.h),
        PasswordTextFormField(
          controller: confirmPasswordController,
          hintText: 'Confirm New Password'.tr(),
          validator: (value) => Validators.repeatPasswordValidator(
            value: value,
            Password: newPasswordController.text,
          ),
          borderColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
