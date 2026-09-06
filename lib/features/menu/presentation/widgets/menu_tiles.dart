import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/routing/routes.dart';
import 'package:the_one_test/core/widgets/under_construction_screen.dart';
import 'package:the_one_test/features/account/presentation/views/account_view.dart';
import 'package:the_one_test/features/orders/presentation/views/previous_orders_view.dart';

import 'menu_tile.dart';

void _openUnderConstruction(BuildContext context, String title) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => UnderConstructionScreen(title: title)),
  );
}

void _toggleLanguage(BuildContext context) {
  final isEnglish = context.locale.languageCode == 'en';
  context.setLocale(isEnglish ? const Locale('ar') : const Locale('en'));
}

Future<void> _logout(BuildContext context) async {
  await getIt<UserSessionCache>().clearUser();
  if (!context.mounted) return;
  Navigator.pushNamedAndRemoveUntil(
    context,
    Routes.loginView,
    (route) => false,
  );
}

List<MenuTile> buildMenuTiles(BuildContext context) {
  return [
    MenuTile(
      icon: Icons.person_outline,
      label: 'My Account'.tr(),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountView()),
      ),
    ),
    MenuTile(
      icon: Icons.receipt_long_outlined,
      label: 'My Previous Orders'.tr(),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PreviousOrdersView()),
      ),
    ),
    MenuTile(
      icon: Icons.help_outline,
      label: 'FAQ'.tr(),
      onTap: () => _openUnderConstruction(context, 'FAQ'.tr()),
    ),
    MenuTile(
      icon: Icons.groups_outlined,
      label: 'About Us'.tr(),
      onTap: () => _openUnderConstruction(context, 'About Us'.tr()),
    ),
    MenuTile(
      icon: Icons.translate,
      label: 'Change Language'.tr(),
      onTap: () => _toggleLanguage(context),
    ),
    MenuTile(
      icon: Icons.privacy_tip_outlined,
      label: 'Privacy Policy'.tr(),
      onTap: () => _openUnderConstruction(context, 'Privacy Policy'.tr()),
    ),
    MenuTile(
      icon: Icons.logout,
      label: 'Logout'.tr(),
      onTap: () => _logout(context),
    ),
    MenuTile(
      icon: Icons.location_on_outlined,
      label: 'Saved Addresses'.tr(),
      onTap: () => _openUnderConstruction(context, 'Saved Addresses'.tr()),
    ),
  ];
}
