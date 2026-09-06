import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'shape.dart';

/// The shared chrome for every auth screen: a clipped primary-color hero
/// background behind a scrollable [header] + [formCard] column.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.header,
    required this.formCard,
    this.headerHeightFactor = 0.35,
  });

  final Widget header;
  final Widget formCard;
  final double headerHeightFactor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.languageCode),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                width: double.infinity,
                height: context.screenHeight * headerHeightFactor,
                color: AppColors.primaryColor,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    header,
                    Gap(28.h),
                    formCard,
                    Gap(24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
