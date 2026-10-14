import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class AccountInfoFields extends StatelessWidget {
  const AccountInfoFields({
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
        _AccountInfoField(
          hintText: 'First Name'.tr(),
          icon: Icons.person_outline,
          controller: firstNameController,
        ),
        Gap(12.h),
        _AccountInfoField(
          hintText: 'Last Name'.tr(),
          icon: Icons.person_outline,
          controller: lastNameController,
        ),
        Gap(12.h),
        _AccountInfoField(
          hintText: 'Phone'.tr(),
          icon: Icons.phone_outlined,
          controller: phoneController,
        ),
        Gap(12.h),
        _AccountInfoField(
          hintText: 'Email'.tr(),
          icon: Icons.email_outlined,
          controller: emailController,
        ),
      ],
    );
  }
}

/// A read-only info row — purely for display, the user can't type into it
/// (no [TextFormField], so there's no focus/cursor/keyboard to trigger).
class _AccountInfoField extends StatelessWidget {
  const _AccountInfoField({
    required this.hintText,
    required this.icon,
    required this.controller,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final value = controller.text;

    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22.sp, color: AppColors.primaryColor),
          Gap(12.w),
          Expanded(
            child: Text(
              value.isEmpty ? hintText : value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                color: value.isEmpty ? Colors.grey.shade400 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
