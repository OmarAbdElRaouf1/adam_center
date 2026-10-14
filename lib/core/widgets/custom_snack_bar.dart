import 'package:flutter/material.dart';
import '../constant/app_colors.dart';
import '../constant/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

OverlayEntry? _currentToast;

/// Shows a small toast that slides down from the top, stays briefly, then
/// slides back up. Only one is visible at a time — a new one replaces the
/// current one right away so rapid taps don't stack.
void showCustomSnackBar(
  BuildContext context,
  String text, {
  IconData icon = Icons.check_circle,
  Color iconColor = Colors.green,
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  // The app-wide navigator's overlay outlives the calling page, so a toast
  // fired as that page closes (e.g. after placing an order) still shows;
  // the caller's context is only needed as a fallback.
  final overlay =
      navigatorKey.currentState?.overlay ??
      (context.mounted ? Overlay.maybeOf(context, rootOverlay: true) : null);
  if (overlay == null) return;

  _currentToast?.remove();
  _currentToast = null;

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _TopToast(
      text: text,
      icon: icon,
      iconColor: iconColor,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onDismissed: () {
        if (_currentToast == entry) _currentToast = null;
        if (entry.mounted) entry.remove();
      },
    ),
  );
  _currentToast = entry;
  overlay.insert(entry);
}

class _TopToast extends StatefulWidget {
  const _TopToast({
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.onDismissed,
    this.actionLabel,
    this.onActionPressed,
  });

  final String text;
  final IconData icon;
  final Color iconColor;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final VoidCallback onDismissed;

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  static const _visibleFor = Duration(seconds: 2);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
    reverseDuration: const Duration(milliseconds: 260),
  );
  late final Animation<Offset> _slide =
      Tween(begin: const Offset(0, -1.6), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        ),
      );

  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(_controller.duration! + _visibleFor, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_closing || !mounted) return;
    _closing = true;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF231F20);

    return Positioned(
      top: MediaQuery.paddingOf(context).top + 8.h,
      left: 24.w,
      right: 24.w,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _controller,
          child: GestureDetector(
            // Flick it back up to close early.
            onVerticalDragEnd: (details) {
              if ((details.primaryVelocity ?? 0) < 0) _dismiss();
            },
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: onSurface.withValues(alpha: 0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: widget.iconColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        widget.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: onSurface,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    if (widget.actionLabel != null)
                      TextButton(
                        onPressed: () {
                          widget.onActionPressed?.call();
                          _dismiss();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          widget.actionLabel!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
