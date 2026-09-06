import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/auth/presentation/manager/login_bloc/login_bloc.dart';
import 'package:the_one_test/features/auth/presentation/views/signup_view.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_switch_link.dart';
import 'package:the_one_test/features/auth/presentation/widgets/login_credentials_fields.dart';
import 'package:the_one_test/features/home/presentation/views/root_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, BaseState<UserModel>>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.showSuccessMessage("Login successful".tr());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RootView()),
            (route) => false,
          );
        } else if (state.isFailure && state.errorMessage != null) {
          context.showErrorMessage(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginCredentialsFields(
                phoneController: phoneController,
                passwordController: passwordController,
              ),

              Gap(12.h),

              CustomElevatedButton.filled(
                backgroundColor: AppColors.primaryColor,
                title: state.isLoading ? 'Logging in...'.tr() : 'Login'.tr(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(
                      LoginEvent(
                        phone: phoneController.text,
                        password: passwordController.text,
                      ),
                    );
                  }
                },
                context: context,
              ),

              Gap(16.h),

              AuthSwitchLink(
                question: 'Don\'t have an account?'.tr(),
                actionLabel: 'Sign Up'.tr(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupView()),
                  );
                },
              ),
              Gap(16.h),
            ],
          ),
        );
      },
    );
  }
}
