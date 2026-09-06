import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/routing/routes.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_back_row.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_header.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_scaffold.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: AuthHeader(
        icon: Icons.lock_outline,
        title: 'Reset Password'.tr(),
        topRow: const AuthBackRow(),
      ),
      formCard: AuthFormCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Gap(20.h),
              CustomElevatedButton.filled(
                backgroundColor: AppColors.primaryColor,
                title: 'Reset Password'.tr(),
                context: context,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.showSuccessMessage(
                      'Password reset successfully'.tr(),
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.loginView,
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
