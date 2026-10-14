import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/custom_snack_bar.dart';

const String contactPhoneNumber = '201040338171';

// Store's social pages for the contact menu. While a link is empty its
// button still shows and tells the user the page isn't available yet.
const String instagramUrl = '';
const String tiktokUrl = '';
const String snapchatUrl = '';

Future<void> openExternalUrl(BuildContext context, String url) async {
  if (url.isEmpty) {
    showCustomSnackBar(
      context,
      'Coming soon'.tr(),
      icon: Icons.info_outline,
      iconColor: Colors.white70,
    );
    return;
  }
  var launched = false;
  try {
    launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (_) {}

  if (!launched && context.mounted) {
    showCustomSnackBar(
      context,
      'Unable to open link'.tr(),
      icon: Icons.error_outline,
      iconColor: Colors.redAccent,
    );
  }
}

Future<void> openWhatsApp(BuildContext context) async {
  var launched = false;
  try {
    launched = await launchUrl(
      Uri.parse('https://wa.me/$contactPhoneNumber'),
      mode: LaunchMode.externalApplication,
    );
  } catch (_) {}

  if (!launched && context.mounted) {
    showCustomSnackBar(
      context,
      'Unable to open WhatsApp'.tr(),
      icon: Icons.error_outline,
      iconColor: Colors.redAccent,
    );
  }
}

Future<void> callContactPhone() async {
  try {
    await launchUrl(Uri.parse('tel:+$contactPhoneNumber'));
  } catch (_) {}
}
