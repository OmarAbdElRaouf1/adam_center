import 'package:the_one_test/core/helper/helper.dart';

/// The rounded, shadowed surface card wrapping form content on auth screens.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.shadowBlur = 20,
    this.shadowOffset = const Offset(0, 8),
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double shadowBlur;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: context.isDarkMode ? 0.3 : 0.08,
            ),
            blurRadius: shadowBlur.r,
            offset: Offset(shadowOffset.dx.w, shadowOffset.dy.h),
          ),
        ],
      ),
      child: child,
    );
  }
}
