import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/account/presentation/views/change_password_view.dart';
import 'package:the_one_test/features/account/presentation/widgets/delete_account_dialog.dart';

class AccountActionButtons extends StatelessWidget {
  const AccountActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final contentColor = isDark ? Colors.white : AppColors.primaryColor;

    return Column(
      children: [
        CustomElevatedButton.filled(
          context: context,
          title: 'Change Password'.tr(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChangePasswordView()),
            );
          },
          backgroundColor: AppColors.primaryColor,
          borderRadius: AppRadius.pill,
          width: context.screenWidth - 40.w,
          fontSize: 16,
          icon: Icons.lock_outline,
          iconOnRight: true,
        ),
        Gap(14.h),
        CustomElevatedButton.bordered(
          context: context,
          title: 'Delete Account'.tr(),
          onPressed: () => showDeleteAccountDialog(context),
          widthFactor: (context.screenWidth - 40.w) / context.screenWidth,
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          textColor: contentColor,
          textStyle: TextStyle(fontSize: 16.sp, color: contentColor),
          borderRadius: AppRadius.pill,
          icon: Icons.delete_outline,
          iconColor: contentColor,
          iconOnRight: true,
        ),
      ],
    );
  }
}
