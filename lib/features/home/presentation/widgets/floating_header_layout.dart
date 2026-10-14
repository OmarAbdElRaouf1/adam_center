import 'package:flutter/rendering.dart';
import 'package:the_one_test/core/helper/helper.dart';

/// Pins [header] just under the status bar, floating over the page, while
/// the content built by [bodyBuilder] scrolls beneath it — so content passes
/// behind the header and through the status-bar area above it.
///
/// [bodyBuilder] gets the height the header covers (status bar + header) to
/// use as its scroll view's top padding, so the content starts right under
/// the header.
class FloatingHeaderLayout extends StatefulWidget {
  const FloatingHeaderLayout({
    super.key,
    required this.header,
    required this.bodyBuilder,
  });

  final Widget header;
  final Widget Function(BuildContext context, double topInset) bodyBuilder;

  @override
  State<FloatingHeaderLayout> createState() => _FloatingHeaderLayoutState();
}

class _FloatingHeaderLayoutState extends State<FloatingHeaderLayout> {
  double _headerHeight = 0;

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        Positioned.fill(
          child: widget.bodyBuilder(context, statusBar + _headerHeight),
        ),
        Positioned(
          top: statusBar,
          left: 0,
          right: 0,
          // The header sits below the status bar already, so it shouldn't
          // pad for it again.
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: _MeasureHeight(
              onChanged: (height) {
                if (height != _headerHeight) {
                  setState(() => _headerHeight = height);
                }
              },
              child: widget.header,
            ),
          ),
        ),
      ],
    );
  }
}

/// Reports its child's laid-out height.
class _MeasureHeight extends SingleChildRenderObjectWidget {
  const _MeasureHeight({required this.onChanged, required super.child});

  final ValueChanged<double> onChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureHeight(onChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMeasureHeight renderObject,
  ) {
    renderObject.onChanged = onChanged;
  }
}

class _RenderMeasureHeight extends RenderProxyBox {
  _RenderMeasureHeight(this.onChanged);

  ValueChanged<double> onChanged;
  double? _last;

  @override
  void performLayout() {
    super.performLayout();
    final height = size.height;
    if (height == _last) return;
    _last = height;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChanged(height));
  }
}
