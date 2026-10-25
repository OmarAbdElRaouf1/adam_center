import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

/// The store's emblem: the gold-on-black logo framed as a rounded badge
/// with a thin gold border and a soft gold glow, so it reads cleanly on
/// both light and dark surfaces.
class StoreLogo extends StatelessWidget {
  const StoreLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.24);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Fills any transparent edge of the asset so the badge stays solid.
        color: Colors.black,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.28),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.05),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.8),
          width: (size * 0.02).clamp(1.0, 2.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          AppAssets.appLogo,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          semanticLabel: 'Malki Scarf'.tr(),
        ),
      ),
    );
  }
}
