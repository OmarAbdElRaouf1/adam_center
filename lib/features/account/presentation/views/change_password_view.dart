import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/account/presentation/manager/change_password_cubit/change_password_cubit.dart';
import 'package:the_one_test/features/account/presentation/widgets/change_password_fields.dart';

import '../../../../core/widgets/widgets/custom_button.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordStatus>(
        listener: (context, status) {
          if (status == ChangePasswordStatus.success) {
            context.showSuccessMessage('Password changed successfully'.tr());
            Navigator.pop(context);
          }
        },
        builder: (context, status) {
          return Scaffold(
            key: ValueKey(context.locale.languageCode),
            appBar: const CustomAppBar(titleText: 'Change Password'),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 96.w,
                        height: 96.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryColor,
                          size: 44.sp,
                        ),
                      ),
                    ),
                    Gap(28.h),
                    ChangePasswordFields(
                      oldPasswordController: oldPasswordController,
                      newPasswordController: newPasswordController,
                      confirmPasswordController: confirmPasswordController,
                    ),
                    Gap(28.h),
                    CustomElevatedButton.filled(
                      context: context,
                      title: 'Change Password'.tr(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ChangePasswordCubit>().submit();
                        }
                      },
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: AppRadius.pill,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
