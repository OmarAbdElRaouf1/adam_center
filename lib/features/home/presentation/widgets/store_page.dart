import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_chat_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_breadcrumb.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';

/// Inner page without the bottom nav (checkout, account, orders, …): the
/// store header with a back button, a "Home › [title]" breadcrumb, then
/// [child] filling the rest. [bottomBar] pins a sheet to the bottom.
class StorePage extends StatelessWidget {
  const StorePage({
    super.key,
    required this.title,
    required this.child,
    this.bottomBar,
  });

  final String title;
  final Widget child;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const HomeChatButton(),
      bottomNavigationBar: bottomBar,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const StoreHeader(showMenu: false),
            Gap(24.h),
            StoreBreadcrumb(current: title),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// White rounded section surface used on the inner pages.
class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
      ),
      child: child,
    );
  }
}

/// Section heading on the inner pages (e.g. "Payment Method").
class StoreSectionLabel extends StatelessWidget {
  const StoreSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
    );
  }
}
