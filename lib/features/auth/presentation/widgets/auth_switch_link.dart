import 'package:the_one_test/core/helper/helper.dart';

class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.question,
    required this.actionLabel,
    required this.onPressed,
  });

  final String question;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: TextStyle(fontSize: 15.sp)),
        TextButton(
          onPressed: onPressed,
          child: Text(actionLabel, style: TextStyle(fontSize: 15.sp)),
        ),
      ],
    );
  }
}
