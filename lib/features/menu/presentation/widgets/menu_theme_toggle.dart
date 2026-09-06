import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:the_one_test/core/helper/helper.dart';

class MenuThemeToggle extends StatelessWidget {
  const MenuThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = context.isDarkMode;

        void toggle() => context.read<ThemeBloc>().add(
          ThemeChanged(isDark ? ThemeMode.light : ThemeMode.dark),
        );

        return Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.card.r),
            onTap: toggle,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.card.r),
                boxShadow: AppShadows.card(context),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: context.screenWidth * 0.1,
                    height: context.screenWidth * 0.1,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(AppRadius.badge.r),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) => RotationTransition(
                        turns: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        key: ValueKey(isDark),
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Text(
                      'Dark Mode'.tr(),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Switch.adaptive(
                    value: isDark,
                    activeThumbColor: AppColors.primaryColor,
                    onChanged: (_) => toggle(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
