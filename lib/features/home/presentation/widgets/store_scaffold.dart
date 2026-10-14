import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/views/root_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/app_drawer.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_chat_button.dart';

/// Pops back to the home screen ([RootView]). Not `route.isFirst`: with an
/// initial route like '/rootView' Flutter pushes an (undefined) '/' route
/// beneath it, and AppRouter's routes carry no names to match on.
void popToStoreRoot(BuildContext context) {
  Navigator.popUntil(
    context,
    (route) => RootView.isRootRoute(route) || route.isFirst,
  );
}

/// Scaffold for the store's inner pages: the shared drawer, bottom nav and
/// chat button. Pass [bottomNavigationBar] to replace the nav (e.g. the
/// product page's add-to-cart bar).
class StoreScaffold extends StatelessWidget {
  const StoreScaffold({
    super.key,
    required this.body,
    this.currentTab,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final Widget body;
  final HomeTab? currentTab;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
      body: body,
      bottomNavigationBar:
          bottomNavigationBar ?? HomeBottomNavBar(current: currentTab),
      floatingActionButton: floatingActionButton ?? const HomeChatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
