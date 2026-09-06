import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/auth/presentation/manager/signup_bloc/signup_bloc.dart';
import 'package:the_one_test/features/auth/presentation/views/login_view.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_switch_link.dart';
import 'package:the_one_test/features/auth/presentation/widgets/location_dropdowns.dart';
import 'package:the_one_test/features/auth/presentation/widgets/signup_credentials_fields.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GovernorateModel? _selectedGovernorate;
  DistrictModel? _selectedDistrict;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, BaseState<UserModel>>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.showSuccessMessage("Signup successful".tr());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignupCredentialsFields(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                phoneController: phoneController,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
              ),

              Gap(16.h),

              LocationDropdowns(
                onSelectionChanged: (governorate, district) => setState(() {
                  _selectedGovernorate = governorate;
                  _selectedDistrict = district;
                }),
              ),

              Gap(16.h),
              CustomTextFormField(
                maxLines: 3,
                hintText: 'Notes on Address'.tr(),
                validator: Validators.notesOnAddress,
                controller: notesController,
                borderColor: AppColors.primaryColor,
              ),

              Gap(24.h),

              CustomElevatedButton.filled(
                backgroundColor: AppColors.primaryColor,
                title: state.isLoading ? 'Signing up...'.tr() : 'Sign Up'.tr(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignupBloc>().add(
                      SignupEvent(
                        phone: phoneController.text,
                        password: passwordController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text.trim(),
                        notes: notesController.text,
                        governorateName: _selectedGovernorate?.name,
                        districtName: _selectedDistrict?.name,
                      ),
                    );
                  }
                },
                context: context,
              ),

              Gap(12.h),

              AuthSwitchLink(
                question: 'Already have an account?'.tr(),
                actionLabel: 'Login'.tr(),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
