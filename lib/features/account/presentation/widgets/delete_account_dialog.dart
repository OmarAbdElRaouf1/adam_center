import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/routing/routes.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      bool isDeleting = false;

      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          Future<void> confirmDelete() async {
            setDialogState(() => isDeleting = true);
            final result = await getIt<AccountCubit>().deleteAccount();
            if (!dialogContext.mounted) return;
            result.fold(
              (failure) {
                setDialogState(() => isDeleting = false);
                dialogContext.showErrorMessage(failure.message);
              },
              (_) {
                Navigator.pop(dialogContext);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginView,
                  (route) => false,
                );
              },
            );
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sheet.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: AppColors.red,
                      size: 32.sp,
                    ),
                  ),
                  Gap(16.h),
                  Text(
                    'Delete Account'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(8.h),
                  Text(
                    'Are you sure you want to delete this account?'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomElevatedButton.bordered(
                          context: context,
                          title: 'Cancel'.tr(),
                          onPressed: isDeleting
                              ? () {}
                              : () => Navigator.pop(dialogContext),
                          borderRadius: AppRadius.pill,
                          widthFactor: 0.35,
                          textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Gap(4.w),
                      Expanded(
                        child: CustomElevatedButton.filled(
                          context: context,
                          title: 'Confirm'.tr(),
                          isLoading: isDeleting,
                          onPressed: isDeleting ? () {} : confirmDelete,
                          backgroundColor: AppColors.red,
                          borderRadius: AppRadius.pill,
                          widthFactor: 0.35,
                          height: 55,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
