import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/auth/presentation/views/forget_password_view.dart';

class LoginCredentialsFields extends StatelessWidget {
  const LoginCredentialsFields({
    super.key,
    required this.phoneController,
    required this.passwordController,
  });

  final TextEditingController phoneController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextFormField(
          hintText: 'Phone'.tr(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          prefixIcon: Icons.phone,
          controller: phoneController,
          validator: Validators.phoneNumberValidator,
          borderColor: AppColors.primaryColor,
        ),

        Gap(16.h),

        PasswordTextFormField(
          validator: Validators.passwordValidator,
          controller: passwordController,
          hintText: 'Password'.tr(),
          borderColor: AppColors.primaryColor,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgetPasswordView()),
              );
            },
            child: Text(
              'Forgot Password?'.tr(),
              style: TextStyle(color: AppColors.primaryColor, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
