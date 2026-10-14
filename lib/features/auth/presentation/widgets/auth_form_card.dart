import 'package:the_one_test/core/helper/helper.dart';

/// The white rounded card wrapping form content on auth screens.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
        boxShadow: AppShadows.card(context),
      ),
      child: child,
    );
  }
}
