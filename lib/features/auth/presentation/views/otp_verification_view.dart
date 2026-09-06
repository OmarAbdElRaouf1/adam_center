import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_back_row.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_header.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:the_one_test/features/auth/presentation/widgets/otp_form.dart';

class OtpVerificationView extends StatelessWidget {
  const OtpVerificationView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: AuthHeader(
        icon: Icons.sms_outlined,
        title: 'Verify Code'.tr(),
        topRow: const AuthBackRow(),
      ),
      formCard: AuthFormCard(child: OtpForm(email: email)),
    );
  }
}
