import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/auth/presentation/views/otp_verification_view.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_back_row.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_header.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_scaffold.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: AuthHeader(
        icon: Icons.lock_reset,
        title: 'Forgot Password?'.tr(),
        topRow: const AuthBackRow(),
      ),
      formCard: AuthFormCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter your email to receive a verification code'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
              ),
              Gap(20.h),
              CustomTextFormField(
                hintText: 'Email'.tr(),
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: Validators.emailValidator,
                borderColor: AppColors.primaryColor,
              ),
              Gap(20.h),
              CustomElevatedButton.filled(
                backgroundColor: AppColors.primaryColor,
                title: 'Send Code'.tr(),
                context: context,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OtpVerificationView(email: emailController.text),
                      ),
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
