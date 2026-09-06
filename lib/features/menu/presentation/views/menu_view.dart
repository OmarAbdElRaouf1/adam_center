import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_contact_fab.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_grid.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_header.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_social_section.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_theme_toggle.dart';
import 'package:the_one_test/features/menu/presentation/widgets/menu_version_footer.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  const MenuHeader(),
                  Gap(20.h),
                  const MenuThemeToggle(),
                  Gap(20.h),
                  const MenuGrid(),
                  Gap(24.h),
                  const MenuSocialSection(),
                  Gap(16.h),
                  const MenuVersionFooter(),
                  Gap(70.h),
                ],
              ),
            ),
            PositionedDirectional(
              bottom: 10.h,
              end: 10.w,
              child: const MenuContactFab(),
            ),
          ],
        ),
      ),
    );
  }
}
