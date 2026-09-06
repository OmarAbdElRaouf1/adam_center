import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/auth/presentation/views/new_password_view.dart';

import 'otp_box_row.dart';
import 'otp_email_notice.dart';
import 'resend_code_row.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key, required this.email});

  final String email;

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  static const int _otpLength = 4;
  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );
  String? _errorText;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      index < _otpLength - 1
          ? _focusNodes[index + 1].requestFocus()
          : _focusNodes[index].unfocus();
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_errorText != null) setState(() => _errorText = null);
  }

  void _verify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != _otpLength) {
      setState(() => _errorText = 'Please enter the complete code'.tr());
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewPasswordView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OtpEmailNotice(email: widget.email),
        Gap(24.h),
        OtpBoxRow(
          length: _otpLength,
          controllers: _controllers,
          focusNodes: _focusNodes,
          onChanged: _onChanged,
        ),
        if (_errorText != null) ...[
          Gap(10.h),
          Text(
            _errorText!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 12.sp),
          ),
        ],
        Gap(24.h),
        CustomElevatedButton.filled(
          backgroundColor: AppColors.primaryColor,
          title: 'Verify'.tr(),
          context: context,
          onPressed: _verify,
        ),
        Gap(16.h),
        const ResendCodeRow(),
      ],
    );
  }
}
