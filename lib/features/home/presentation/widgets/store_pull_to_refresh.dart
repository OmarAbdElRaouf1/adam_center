import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/pull_to_refresh.dart';

/// The app's pull-to-refresh (core [PullToRefresh]) set up for the store
/// pages: the indicator sits under the header ([topInset] is the space the
/// header covers), and horizontal scrolling inside the page (carousels,
/// category rows) is kept from reaching it — only the page's own vertical
/// scroll counts as a pull. [builder] must attach the given controller to
/// an always-scrollable vertical scroll view.
class StorePullToRefresh extends StatelessWidget {
  const StorePullToRefresh({
    super.key,
    required this.onRefresh,
    required this.builder,
    this.topInset = 0,
  });

  final Future<void> Function() onRefresh;
  final Widget Function(ScrollController controller) builder;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      topPadding: topInset + 44.h,
      // Never let a failed refresh throw into PullToRefresh — it would never
      // clear its refreshing state and the indicator would spin forever.
      onRefresh: () async {
        try {
          await onRefresh();
        } catch (_) {}
      },
      builder: (controller) => NotificationListener<ScrollNotification>(
        onNotification: (n) => n.metrics.axis == Axis.horizontal,
        child: builder(controller),
      ),
    );
  }
}

/// Completes once [bloc] has finished the load that was just requested, so
/// the refresh indicator stays up until fresh data is on screen.
Future<void> untilLoaded<T>(BlocBase<BaseState<T>> bloc) => bloc.stream
    .firstWhere((state) => !state.isLoading)
    .timeout(const Duration(seconds: 15), onTimeout: () => bloc.state);
