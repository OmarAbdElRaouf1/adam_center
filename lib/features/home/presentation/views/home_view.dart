import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';

import 'package:the_one_test/features/home/presentation/views/barcode_scanner_view.dart';
import 'package:the_one_test/features/home/presentation/views/search_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/floating_header_layout.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_top_bar.dart';

import '../widgets/home_view_body.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_pull_to_refresh.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Bumped on pull-to-refresh: a new key rebuilds the body, so every banner
  // and product section re-creates its bloc and fetches again.
  int _refreshCount = 0;

  Future<void> _onRefresh() async {
    final categoryBloc = context.read<CategoryBloc>();
    categoryBloc.add(const GetMainCategoriesEvent());
    setState(() => _refreshCount++);
    await untilLoaded(categoryBloc);
  }

  void _openSearch({String? query}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchView(initialQuery: query)),
    );
  }

  Future<void> _onScanTap() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerView()),
    );

    if (!mounted || code == null || code.isEmpty) return;
    _openSearch(query: code);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingHeaderLayout(
      header: HomeTopBar(onSearchTap: _openSearch, onScanTap: _onScanTap),
      bodyBuilder: (context, topInset) => StorePullToRefresh(
        topInset: topInset,
        onRefresh: _onRefresh,
        builder: (controller) => SingleChildScrollView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: topInset,
            bottom: MediaQuery.paddingOf(context).bottom + 40.h,
          ),
          child: HomeViewBody(key: ValueKey(_refreshCount)),
        ),
      ),
    );
  }
}
