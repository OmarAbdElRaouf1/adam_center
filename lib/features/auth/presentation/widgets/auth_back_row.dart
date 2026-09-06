import 'package:the_one_test/core/helper/helper.dart';

import 'lanuage_toggle.dart';

/// The back-button + language-toggle row shown above [AuthHeader] on
/// secondary auth screens (forgot password, reset password, OTP).
class AuthBackRow extends StatelessWidget {
  const AuthBackRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 4, start: 4, end: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const LanguageToggle(),
        ],
      ),
    );
  }
}
