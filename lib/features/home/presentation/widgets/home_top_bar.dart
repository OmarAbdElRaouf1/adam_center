import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';
import 'package:the_one_test/features/favorites/data/datasource/local_favorites_store.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 44.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PositionedDirectional(
                start: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () =>
                          context.read<NavBarCubit>().changeIndex(3),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                          Positioned(
                            right: -6,
                            top: -6,
                            child:
                                BlocBuilder<
                                  FavoriteBloc,
                                  BaseState<ItemModel>
                                >(
                                  bloc: getIt<FavoriteBloc>(),
                                  builder: (context, state) {
                                    final count = getIt<LocalFavoritesStore>()
                                        .getIds()
                                        .length;

                                    if (count == 0) {
                                      return const SizedBox.shrink();
                                    }

                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 16.w,
                                        minHeight: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.localizeDigits(
                                            count.toString(),
                                          ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9.sp,
                                            height: 1,
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
                    Gap(16.w),
                    InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () =>
                          context.read<NavBarCubit>().changeIndex(2),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                          Positioned(
                            right: -6,
                            top: -6,
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

                                    if (count == 0) {
                                      return const SizedBox.shrink();
                                    }

                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 16.w,
                                        minHeight: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.localizeDigits(
                                            count.toString(),
                                          ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9.sp,
                                            height: 1,
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
                  ],
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Malki Scarf'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(2.h),
                  BlocBuilder<AccountCubit, UserModel?>(
                    bloc: getIt<AccountCubit>(),
                    builder: (context, user) {
                      final district =
                          districtFromCustomerAddress(
                            user?.customerAddress,
                          ) ??
                          user?.districtName;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryColor,
                            size: 12.sp,
                          ),
                          Gap(2.w),
                          Text(
                            [
                              user?.regionName,
                              district,
                            ].whereType<String>().join(', '),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              PositionedDirectional(
                end: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Icon(
                    Icons.menu_rounded,
                    color: AppColors.primaryColor,
                    size: 26.sp,
                  ),
                ),
              ),
            ],
          ),
        ),

        Gap(16.h),

        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.badge.r),
              onTap: onScanTap,
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(AppRadius.badge.r),
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),

            Gap(10.w),

            Expanded(
              child: CustomSearchField(
                controller: searchController,
                onChanged: onSearchChanged,
                onClear: onSearchClear,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
