import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class MenuVersionFooter extends StatelessWidget {
  const MenuVersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.description_outlined, size: 14.sp, color: Colors.grey),
        Gap(6.w),
        Text(
          context.localizeDigits('${'Version'.tr()} 1.1.10'),
          style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
