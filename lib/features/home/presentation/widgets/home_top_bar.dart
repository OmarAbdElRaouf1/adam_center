import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';

import '../../../../core/helper/helper.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: context.screenHeight * 0.08,
      padding: const EdgeInsetsDirectional.only(start: 20, end: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.sheet.r),
        boxShadow: AppShadows.card(context),
      ),

      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChooseAddressView()),
              ),
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
                  // AccountCubit is a shared, app-wide singleton — reading it
                  // via `bloc:` here means an address change from Cart (or
                  // anywhere else) shows up here immediately, with no manual
                  // refresh wiring needed between screens.
                  BlocBuilder<AccountCubit, UserModel?>(
                    bloc: getIt<AccountCubit>(),
                    builder: (context, user) {
                      final district =
                          districtFromCustomerAddress(user?.customerAddress) ??
                          user?.districtName;
                      return Text(
                        '${user?.regionName}, $district',
                        style: AppTextTheme.body2Bold.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CartBloc is a shared, app-wide singleton (see
              // CartServiceLocator) — the same instance the Cart tab itself
              // reads, so this count is always in sync with it.
              BlocBuilder<CartBloc, BaseState<CartItemModel>>(
                bloc: getIt<CartBloc>(),
                builder: (context, state) {
                  final count = state.items.fold<int>(
                    0,
                    (sum, item) => sum + item.salesQuantity,
                  );
                  if (count == 0) return const SizedBox.shrink();
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.localizeDigits(count.toString()),
                        style: AppTextTheme.titleLargeBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Gap(5.w),
                    ],
                  );
                },
              ),
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
