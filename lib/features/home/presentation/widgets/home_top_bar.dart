import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';

import '../../../../core/helper/helper.dart';

class HomeTopBar extends StatelessWidget {
  HomeTopBar({super.key});
  final user = getIt<UserSessionCache>().getUser();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      padding: const EdgeInsetsDirectional.only(start: 20, end: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.sheet.r),
        boxShadow: AppShadows.card(context),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Address'.tr(),
                  style: AppTextTheme.captionBold.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Gap(3.h),
                Text(
                  '${user?.regionName}, ${user?.districtName}',
                  style: AppTextTheme.body2Bold.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.localizeDigits('2'),
                style: AppTextTheme.titleLargeBold.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              Gap(5.w),
              IconButton(
                onPressed: () {
                  context.read<NavBarCubit>().changeIndex(2);
                },
                icon: SvgPicture.asset('assets/images/cart.svg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
