import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:gap/gap.dart';
import 'package:the_one_test/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/routing/routes.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/account/presentation/views/account_view.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/category_products/data/models/category_model.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_selection_cubit/category_selection_cubit.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';
import 'package:the_one_test/features/favorites/presentation/views/favorites_view.dart';
import 'package:the_one_test/features/home/presentation/views/categories_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/contact_launcher.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_page.dart';
import 'package:the_one_test/features/menu/data/datasource/info_pages_datasource.dart';
import 'package:the_one_test/features/menu/presentation/views/info_images_view.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_version_footer.dart';
import 'package:the_one_test/features/orders/presentation/views/previous_orders_view.dart';

void _openPage(BuildContext context, Widget page) {
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

Future<void> _logout(BuildContext context) async {
  Navigator.pop(context);
  await getIt<AccountCubit>().logout();
  if (!context.mounted) return;
  Navigator.pushNamedAndRemoveUntil(
    context,
    Routes.loginView,
    (route) => false,
  );
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: context.screenWidth * 0.7,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _DrawerHeader(),
              const _DrawerDivider(),
              Gap(12.h),
              const _DrawerCategories(),
              const _DrawerDivider(),
              _DrawerTextTile(
                label: 'Contact Us'.tr(),
                onTap: () {
                  Navigator.pop(context);
                  openWhatsApp(context);
                },
              ),
              _DrawerTextTile(
                label: 'About Us'.tr(),
                onTap: () => _openPage(
                  context,
                  InfoImagesView(
                    title: 'About Us'.tr(),
                    fetcher: () => getIt<InfoPagesDatasource>().getAboutUs(),
                  ),
                ),
              ),
              _DrawerTextTile(
                label: 'Privacy Policy'.tr(),
                onTap: () => _openPage(
                  context,
                  InfoImagesView(
                    title: 'Privacy Policy'.tr(),
                    fetcher: () =>
                        getIt<InfoPagesDatasource>().getPrivacyPolicy(),
                  ),
                ),
              ),
              _DrawerTextTile(
                label: 'FAQ'.tr(),
                onTap: () => _openPage(
                  context,
                  StorePage(
                    title: 'FAQ'.tr(),
                    child: Padding(
                      padding: EdgeInsets.only(top: 80.h),
                      child: Text(
                        'Coming soon'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.sp,
                          color: AppColors.primaryColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const _DrawerDivider(),
              _DrawerIconTile(
                icon: Icons.favorite_border_rounded,
                label: 'Favorites'.tr(),
                onTap: () => _openPage(context, const FavoritesView()),
              ),
              const _DrawerLanguageTile(),
              const _DrawerDarkModeTile(),
              const _DrawerLogoutTile(),
              const _DrawerDivider(),
              _DrawerIconTile(
                icon: Icons.phone_outlined,
                label: '+$contactPhoneNumber',
                labelDirection: TextDirection.ltr,
                onTap: callContactPhone,
              ),
              Gap(24.h),
              const MenuVersionFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, UserModel?>(
      bloc: getIt<AccountCubit>(),
      builder: (context, user) {
        final isGuest = user == null;
        final isArabic = context.locale.languageCode == 'ar';
        final name = isGuest
            ? 'Guest'.tr()
            : (isArabic
                      ? (user.arabicName ?? user.englishName)
                      : (user.englishName ?? user.arabicName)) ??
                  '';
        final email = user?.email ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap(24.h),
            Center(
              child: Container(
                width: 112.w,
                height: 112.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Colors.black87,
                  size: 84.sp,
                ),
              ),
            ),
            Gap(14.h),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
            ),
            if (email.isNotEmpty) ...[
              Gap(10.h),
              Text(
                email,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
            Gap(20.h),
            if (isGuest)
              Center(
                child: Material(
                  color: AppColors.primaryColor.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(AppRadius.chip.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.chip.r),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.loginView);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Login'.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap(14.w),
                          Icon(
                            Icons.login_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else ...[
              _DrawerIconTile(
                icon: Icons.person_outline_rounded,
                label: 'Profile'.tr(),
                onTap: () => _openPage(context, const AccountView()),
              ),
              _DrawerIconTile(
                icon: Icons.location_on_outlined,
                label: 'Address Book'.tr(),
                onTap: () => _openPage(context, const ChooseAddressView()),
              ),
              _DrawerIconTile(
                icon: Icons.history_rounded,
                label: 'My Orders'.tr(),
                onTap: () => _openPage(context, const PreviousOrdersView()),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Logout row at the bottom of the drawer; hidden for guests.
class _DrawerLogoutTile extends StatelessWidget {
  const _DrawerLogoutTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, UserModel?>(
      bloc: getIt<AccountCubit>(),
      builder: (context, user) {
        if (user == null) return const SizedBox.shrink();
        return _DrawerIconTile(
          icon: Icons.logout_rounded,
          label: 'Logout'.tr(),
          onTap: () => _logout(context),
        );
      },
    );
  }
}

class _DrawerCategories extends StatelessWidget {
  const _DrawerCategories();

  void _openCategory(BuildContext context, int? id) {
    if (id != null) getIt<CategorySelectionCubit>().select(id);
    _openPage(context, const CategoriesView());
  }

  @override
  Widget build(BuildContext context) {
    // Inner pages are pushed routes outside RootView's CategoryBloc, so the
    // drawer loads its own copy.
    return BlocProvider(
      create: (_) => getIt<CategoryBloc>()..add(const GetMainCategoriesEvent()),
      child: BlocBuilder<CategoryBloc, BaseState<ParentCategoryModel>>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DrawerTextTile(
                label: 'All Categories'.tr(),
                onTap: () => _openCategory(context, null),
              ),
              for (final category in state.items)
                _DrawerTextTile(
                  label: category.title,
                  onTap: () => _openCategory(context, category.id),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.grey.withValues(alpha: 0.12),
      ),
    );
  }
}

class _DrawerTextTile extends StatelessWidget {
  const _DrawerTextTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 10.h),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}

class _DrawerIconTile extends StatelessWidget {
  const _DrawerIconTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.labelDirection,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final TextDirection? labelDirection;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(icon, size: 26.sp),
            Gap(14.w),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  label,
                  textDirection: labelDirection,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _DrawerLanguageTile extends StatelessWidget {
  const _DrawerLanguageTile();

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    void toggle() => context.setLocale(Locale(isArabic ? 'en' : 'ar'));

    return _DrawerIconTile(
      icon: Icons.language_rounded,
      label: 'Language'.tr(),
      onTap: toggle,
      trailing: _PillToggle(
        value: !isArabic,
        onTap: toggle,
        child: Text(
          isArabic ? 'EN' : 'ع',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DrawerDarkModeTile extends StatelessWidget {
  const _DrawerDarkModeTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = context.isDarkMode;

        void toggle() => context.read<ThemeBloc>().add(
          ThemeChanged(isDark ? ThemeMode.light : ThemeMode.dark),
        );

        return _DrawerIconTile(
          icon: Icons.dark_mode_outlined,
          label: 'Dark Mode'.tr(),
          onTap: toggle,
          trailing: _PillToggle(
            value: isDark,
            onTap: toggle,
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: Colors.white,
              size: 14.sp,
            ),
          ),
        );
      },
    );
  }
}

/// Pill switch from the reference design: a white knob on a tinted track,
/// with [child] shown on the side the knob isn't covering.
class _PillToggle extends StatelessWidget {
  const _PillToggle({
    required this.value,
    required this.onTap,
    required this.child,
  });

  final bool value;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final knobAlignment = value
        ? AlignmentDirectional.centerStart
        : AlignmentDirectional.centerEnd;
    final labelAlignment = value
        ? AlignmentDirectional.centerEnd
        : AlignmentDirectional.centerStart;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.w,
        height: 36.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
        ),
        child: Stack(
          children: [
            Align(
              alignment: labelAlignment,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: child,
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: knobAlignment,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
