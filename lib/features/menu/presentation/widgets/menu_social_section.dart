import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class MenuSocialSection extends StatelessWidget {
  const MenuSocialSection({super.key});

  static const _icons = [
    Icons.alternate_email,
    Icons.music_note_outlined,
    Icons.camera_alt_outlined,
    Icons.facebook,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Stay in touch'.tr(),
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
        ),
        Gap(12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final icon in _icons)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    icon,
                    size: 16.sp,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
