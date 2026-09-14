import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';

class CartDeliveryBar extends StatelessWidget {
  const CartDeliveryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        boxShadow: AppShadows.card(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          ),
          Gap(10.w),
          // AccountCubit is a shared, app-wide singleton — reading it here
          // via `bloc:` means an address change made from Home (or anywhere
          // else) shows up here immediately too.
          Expanded(
            child: BlocBuilder<AccountCubit, UserModel?>(
              bloc: getIt<AccountCubit>(),
              builder: (context, user) {
                final region = user?.regionName;
                final label = region == null || region.isEmpty
                    ? 'Deliver to'.tr()
                    : '${'Deliver to'.tr()}: $region';

                return Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChooseAddressView()),
            ),
            icon: Icon(Icons.chevron_left, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
