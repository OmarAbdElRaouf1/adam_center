import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/routing/routes.dart';
import 'package:the_one_test/core/widgets/under_construction_screen.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/account/presentation/views/account_view.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:the_one_test/features/menu/data/datasource/info_pages_datasource.dart';
import 'package:the_one_test/features/menu/presentation/views/info_images_view.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_theme_toggle.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_version_footer.dart';
import 'package:the_one_test/features/orders/presentation/views/previous_orders_view.dart';

void _goToTab(BuildContext context, int index) {
  Navigator.pop(context);
  context.read<NavBarCubit>().changeIndex(index);
}

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primaryColor, AppColors.mainAppColor],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.card.r),
                        boxShadow: AppShadows.card(context),
                      ),
                      child: Icon(
                        Icons.checkroom,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                    Gap(20.h),
                    const _DrawerLanguageSelector(),
                    Gap(12.h),
                    const MenuThemeToggle(),
                    Gap(16.h),
                    const Divider(),
                    Gap(4.h),
                    _DrawerNavTile(
                      icon: Icons.home_outlined,
                      label: 'Home'.tr(),
                      onTap: () => _goToTab(context, 0),
                    ),
                    _DrawerNavTile(
                      icon: Icons.person_outline,
                      label: 'My Account'.tr(),
                      onTap: () => _openPage(context, const AccountView()),
                    ),
                    _DrawerNavTile(
                      icon: Icons.favorite_border,
                      label: 'Favorites'.tr(),
                      onTap: () => _goToTab(context, 3),
                    ),
                    _DrawerNavTile(
                      icon: Icons.receipt_long_outlined,
                      label: 'My Previous Orders'.tr(),
                      onTap: () =>
                          _openPage(context, const PreviousOrdersView()),
                    ),
                    _DrawerNavTile(
                      icon: Icons.groups_outlined,
                      label: 'About Us'.tr(),
                      onTap: () => _openPage(
                        context,
                        InfoImagesView(
                          title: 'About Us'.tr(),
                          fetcher: () =>
                              getIt<InfoPagesDatasource>().getAboutUs(),
                        ),
                      ),
                    ),
                    _DrawerNavTile(
                      icon: Icons.help_outline,
                      label: 'FAQ'.tr(),
                      onTap: () => _openPage(
                        context,
                        UnderConstructionScreen(title: 'FAQ'.tr()),
                      ),
                    ),
                    _DrawerNavTile(
                      icon: Icons.privacy_tip_outlined,
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
                    _DrawerNavTile(
                      icon: Icons.location_on_outlined,
                      label: 'Saved Addresses'.tr(),
                      onTap: () =>
                          _openPage(context, const ChooseAddressView()),
                    ),
                    _DrawerNavTile(
                      icon: Icons.logout,
                      label: 'Logout'.tr(),
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ),
            const MenuVersionFooter(),
            Gap(12.h),
          ],
        ),
      ),
    );
  }
}

class _DrawerLanguageSelector extends StatelessWidget {
  const _DrawerLanguageSelector();

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.languageCode == 'en';

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.card.r),
      onTap: () => context.setLocale(
        isEnglish ? const Locale('ar') : const Locale('en'),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(
              alpha: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.translate, color: AppColors.primaryColor, size: 20.sp),
            Gap(10.w),
            Expanded(
              child: Text(
                isEnglish ? 'English' : 'العربية',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerNavTile extends StatelessWidget {
  const _DrawerNavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Icon(icon, color: AppColors.primaryColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
