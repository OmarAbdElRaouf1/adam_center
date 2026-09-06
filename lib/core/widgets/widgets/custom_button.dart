import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final Widget? child;
  final String? title;
  final VoidCallback? onPressed;
  final double? elevation;
  final Size? minimumSize;
  final Color? overlayColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BorderSide? side;
  final double? borderRadius;
  final Color? textColor;
  final bool isLoading;
  final double loaderSize;
  final int maxLines;
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;
  final double iconSpacing;
  final bool iconOnRight;

  const CustomElevatedButton._({
    this.child,
    this.title,
    this.onPressed,
    this.elevation,
    this.minimumSize,
    this.overlayColor,
    this.shadowColor,
    this.padding,
    this.textStyle,
    this.backgroundColor,
    this.side,
    this.borderRadius,
    this.textColor,
    this.isLoading = false,
    this.loaderSize = 22,
    this.maxLines = 1,
    this.icon,
    this.iconColor,
    this.iconSize = 20,
    this.iconSpacing = 8,
    this.iconOnRight = false,
  }) : assert(
         child != null || title != null,
         'Either child or title must be provided',
       );

  // 🧱 Named constructors

  factory CustomElevatedButton.filled({
    required String title,
    required VoidCallback onPressed,
    required BuildContext context,
    bool isLoading = false,
    double elevation = 0,
    double widthFactor = 0.9,
    Color overlayColor = Colors.transparent,
    Color? shadowColor,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 13,
    ),
    TextStyle? textStyle,
    Color? backgroundColor,
    double borderRadius = 12,
    Color textColor = Colors.white,
    double? width,
    double? height,
    double? fontSize,
    int maxLines = 1,
    double loaderSize = 22,
    IconData? icon,
    Color? iconColor,
    double iconSize = 20,
    double iconSpacing = 8,
    bool iconOnRight = false,
  }) {
    final defaultTextStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: fontSize ?? 20,
      color: textColor,
      fontWeight: FontWeight.bold,
    );

    return CustomElevatedButton._(
      title: title,
      onPressed: onPressed,
      elevation: elevation,
      minimumSize: Size(
        width ?? MediaQuery.of(context).size.width * widthFactor,
        height ?? 50,
      ),
      overlayColor: overlayColor,
      shadowColor:
          shadowColor ?? Theme.of(context).primaryColor.withValues(alpha: 0.1),
      padding: padding,
      textStyle: textStyle ?? defaultTextStyle,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      borderRadius: borderRadius,
      textColor: textColor,
      isLoading: isLoading,
      loaderSize: loaderSize,
      maxLines: maxLines,
      icon: icon,
      iconColor: iconColor ?? textColor,
      iconSize: iconSize,
      iconSpacing: iconSpacing,
      iconOnRight: iconOnRight,
    );
  }

  factory CustomElevatedButton.bordered({
    required String title,
    required VoidCallback onPressed,
    required BuildContext context,
    bool isLoading = false,
    double elevation = 0,
    double widthFactor = 0.9,
    Color overlayColor = Colors.transparent,
    Color? shadowColor,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 13,
    ),
    TextStyle? textStyle,
    Color backgroundColor = Colors.transparent,
    BorderSide? side,
    double borderRadius = 40,
    Color? textColor,
    IconData? icon,
    Color? iconColor,
    double iconSize = 20,
    double iconSpacing = 8,
    bool iconOnRight = false,
  }) {
    final defaultSide = BorderSide(
      color: Theme.of(context).colorScheme.primary,
      width: 2,
    );

    final defaultTextStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: 20,
      color: textColor ?? Theme.of(context).colorScheme.primary,
    );

    return CustomElevatedButton._(
      title: title,
      onPressed: onPressed,
      elevation: elevation,
      minimumSize: Size(MediaQuery.of(context).size.width * widthFactor, 55),
      overlayColor: overlayColor,
      shadowColor:
          shadowColor ??
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      padding: padding,
      textStyle: textStyle ?? defaultTextStyle,
      backgroundColor: backgroundColor,
      side: side ?? defaultSide,
      borderRadius: borderRadius,
      textColor: textColor ?? Theme.of(context).colorScheme.primary,
      isLoading: isLoading,
      icon: icon,
      iconColor:
          iconColor ?? textColor ?? Theme.of(context).colorScheme.primary,
      iconSize: iconSize,
      iconSpacing: iconSpacing,
      iconOnRight: iconOnRight,
    );
  }

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _widthAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    if (widget.isLoading) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CustomElevatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.forward();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLabel() {
    final textWidget = Text(
      widget.title!,
      style:
          widget.textStyle?.copyWith(color: widget.textColor) ??
          TextStyle(color: widget.textColor),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
    );

    if (widget.icon == null) return textWidget;

    final iconWidget = Icon(
      widget.icon,
      color: widget.iconColor ?? widget.textColor,
      size: widget.iconSize,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Center(child: textWidget),
        Align(
          alignment: widget.iconOnRight
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: widget.iconOnRight ? 0 : 24,
              end: widget.iconOnRight ? 24 : 0,
            ),
            child: iconWidget,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double initialWidth =
        widget.minimumSize?.width ?? MediaQuery.of(context).size.width * 0.9;
    final double buttonHeight = widget.minimumSize?.height ?? 50;
    final double targetWidth = buttonHeight; // Make it circular

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentWidth = Tween<double>(
          begin: initialWidth,
          end: targetWidth,
        ).evaluate(_widthAnimation);

        return Center(
          child: SizedBox(
            width: currentWidth,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                elevation: widget.elevation,
                backgroundColor: widget.backgroundColor,
                disabledBackgroundColor: widget.backgroundColor,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 40,
                  ),
                  side: widget.side ?? BorderSide.none,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Text content
                  FadeTransition(
                    opacity: ReverseAnimation(_opacityAnimation),
                    child: widget.child ?? _buildLabel(),
                  ),

                  // Loading indicator
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(
                            0.3,
                            1.0,
                            curve: Curves.elasticOut,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: widget.loaderSize,
                        height: widget.loaderSize,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.textColor ?? Colors.white,
                          ),
                        ),
                      ),
                    ),
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
