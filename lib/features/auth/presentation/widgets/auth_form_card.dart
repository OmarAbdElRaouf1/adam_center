import 'package:the_one_test/core/helper/helper.dart';

/// The rounded, shadowed surface card wrapping form content on auth screens.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.fromLTRB(20, 28, 20, 24),
    this.shadowBlur = 20,
    this.shadowOffset = const Offset(0, 8),
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double shadowBlur;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: context.isDarkMode ? 0.3 : 0.08,
            ),
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
      child: child,
    );
  }
}
