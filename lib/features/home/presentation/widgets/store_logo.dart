import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

/// The store's round emblem.
class StoreLogo extends StatelessWidget {
  const StoreLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.appLogo,
      width: size,
      height: size,
      semanticLabel: 'Malki Scarf'.tr(),
    );
  }
}
