import 'package:the_one_test/core/helper/helper.dart';

import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';

import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:the_one_test/features/home/presentation/views/barcode_scanner_view.dart';

import '../widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  final ProductBloc _searchBloc = getIt<ProductBloc>();

  Timer? _debounce;

  List<int> _matchedCategoryIds(String query) {
    final categories = context.read<CategoryBloc>().state.items;

    return categories
        .where(
          (category) =>
              category.title.toLowerCase().contains(query.toLowerCase()),
        )
        .map((category) => category.id)
        .whereType<int>()
        .toList();
  }

  void _dispatchSearch(String query) {
    if (query.trim().isEmpty) return;

    _searchBloc.add(
      GetSearchResultsEvent(
        query.trim(),
        categoryIds: _matchedCategoryIds(query),
      ),
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    setState(() {});

    final query = value.trim();

    if (query.isEmpty) {
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 200),
      () => _dispatchSearch(query),
    );
  }

  void _onSearchClear() {
    _debounce?.cancel();

    _searchController.clear();

    setState(() {});
  }

  Future<void> _onScanTap() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerView()),
    );

    if (!mounted || code == null || code.isEmpty) {
      return;
    }

    _debounce?.cancel();

    _searchController.text = code;

    setState(() {});

    _dispatchSearch(code);
  }

  void _goToCategories() {
    context.read<NavBarCubit>().changeIndex(1);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchController.text.trim().isNotEmpty;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          top: 5.h,
          bottom: context.screenHeight * 0.12,
        ),
        child: HomeViewBody(
          searchController: _searchController,
          isSearching: isSearching,
          searchBloc: _searchBloc,
          onSearchChanged: _onSearchChanged,
          onSearchClear: _onSearchClear,
          onScanTap: _onScanTap,
          onSeeAllPressed: _goToCategories,
          dispatchSearch: _dispatchSearch,
        ),
      ),
    );
  }
}
