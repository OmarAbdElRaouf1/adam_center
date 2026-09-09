import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

class ResendCodeRow extends StatelessWidget {
  const ResendCodeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code?".tr(),
          style: TextStyle(fontSize: 13.sp),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Resend Code'.tr(), style: TextStyle(fontSize: 13.sp)),
        ),
      ],
    );
  }
}
