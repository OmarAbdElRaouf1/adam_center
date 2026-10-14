import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

/// The shared chrome for every auth screen: a scrollable [header] +
/// [formCard] column on the plain store background.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.header, required this.formCard});

  final Widget header;
  final Widget formCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.languageCode),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            // Capped so the form card doesn't stretch edge to edge on
            // tablets / landscape.
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [header, Gap(28.h), formCard, Gap(24.h)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
