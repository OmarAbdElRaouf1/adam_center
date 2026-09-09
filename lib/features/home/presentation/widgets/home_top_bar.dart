import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';

import '../../../../core/helper/helper.dart';

// Single top app bar for the Home tab: a gradient hero card holding the
// address/cart row plus a floating search field, instead of two separate
// plain-surface blocks.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.searchController,
    this.onSearchChanged,
    this.onSearchClear,
    this.onScanTap,
  });

  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchClear;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sheet.r),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryColor, AppColors.mainAppColor],
          ),
          boxShadow: AppShadows.raised(context),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -36,
              right: -30,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -46,
              left: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 12.w, 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                      Gap(10.w),

                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChooseAddressView(),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Your Address'.tr(),
                                    style: AppTextTheme.captionBold.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                  Gap(2.w),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 16.sp,
                                  ),
                                ],
                              ),
                              // AccountCubit is a shared, app-wide singleton —
                              // reading it via `bloc:` here means an address
                              // change from Cart (or anywhere else) shows up
                              // here immediately, with no manual refresh
                              // wiring needed between screens.
                              BlocBuilder<AccountCubit, UserModel?>(
                                bloc: getIt<AccountCubit>(),
                                builder: (context, user) {
                                  final district =
                                      districtFromCustomerAddress(
                                        user?.customerAddress,
                                      ) ??
                                      user?.districtName;
                                  return Text(
                                    '${user?.regionName}, $district',
                                    style: AppTextTheme.body2Bold.copyWith(
                                      color: Colors.white,
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

                      Gap(8.w),

                      if (onScanTap != null)
                        InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: onScanTap,
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),

                      if (onScanTap != null) Gap(8.w),

                      InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => context.read<NavBarCubit>().changeIndex(
                          2,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                'assets/images/cart.svg',
                                width: 20.w,
                                height: 20.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              // CartBloc is a shared, app-wide singleton (see
                              // CartServiceLocator) — the same instance the
                              // Cart tab itself reads, so this count is
                              // always in sync with it.
                              Positioned(
                                right: -8,
                                top: -8,
                                child:
                                    BlocBuilder<
                                      CartBloc,
                                      BaseState<CartItemModel>
                                    >(
                                      bloc: getIt<CartBloc>(),
                                      builder: (context, state) {
                                        final count = state.items.fold<int>(
                                          0,
                                          (sum, item) =>
                                              sum + item.salesQuantity,
                                        );
                                        return AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 220,
                                          ),
                                          switchInCurve: Curves.easeOutBack,
                                          switchOutCurve: Curves.easeIn,
                                          transitionBuilder:
                                              (child, animation) =>
                                                  ScaleTransition(
                                                    scale: animation,
                                                    child: child,
                                                  ),
                                          child: count == 0
                                              ? const SizedBox.shrink(
                                                  key: ValueKey('no-count'),
                                                )
                                              : Container(
                                                  key: ValueKey(count),
                                                  padding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 5.w,
                                                      ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 18.w,
                                                    minHeight: 18.w,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.red,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      context.localizeDigits(
                                                        count.toString(),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppTextTheme
                                                          .captionBold
                                                          .copyWith(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 10.sp,
                                                            height: 1,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                        );
                                      },
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Gap(16.h),

                  CustomSearchField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    onClear: onSearchClear,
                    fillColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
