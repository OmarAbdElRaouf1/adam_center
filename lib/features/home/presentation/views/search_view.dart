import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_product_grid_shimmer.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/product_sort.dart';
import 'package:the_one_test/features/home/presentation/views/barcode_scanner_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_section_title.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_breadcrumb.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_pull_to_refresh.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key, this.initialQuery});

  /// Pre-fills the field and searches right away (e.g. a scanned barcode).
  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProductBloc>()),
        BlocProvider(
          create: (_) =>
              getIt<CategoryBloc>()..add(const GetMainCategoriesEvent()),
        ),
      ],
      child: _SearchViewBody(initialQuery: initialQuery),
    );
  }
}

class _SearchViewBody extends StatefulWidget {
  const _SearchViewBody({this.initialQuery});

  final String? initialQuery;

  @override
  State<_SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<_SearchViewBody> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialQuery,
  );
  // Kept apart from the search bloc (and alive across typing/clearing) so
  // the suggestions don't reshuffle every time the field is emptied.
  final _suggestionsBloc = getIt<ProductBloc>()
    ..add(const GetSuggestedProductsEvent());
  Timer? _debounce;
  ProductSort _sort = ProductSort.newest;

  bool get _hasQuery => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_hasQuery) _dispatchSearch(_controller.text);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _suggestionsBloc.close();
    super.dispose();
  }

  List<int> _matchedCategoryIds(String query) {
    return context
        .read<CategoryBloc>()
        .state
        .items
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
    context.read<ProductBloc>().add(
      GetSearchResultsEvent(
        query.trim(),
        categoryIds: _matchedCategoryIds(query),
      ),
    );
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    setState(() {});
    if (value.trim().isEmpty) return;
    _debounce = Timer(
      const Duration(milliseconds: 200),
      () => _dispatchSearch(value),
    );
  }

  void _onClear() {
    _debounce?.cancel();
    _controller.clear();
    setState(() {});
  }

  Future<void> _onScanTap() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerView()),
    );
    if (!mounted || code == null || code.isEmpty) return;
    _debounce?.cancel();
    _controller.text = code;
    setState(() {});
    _dispatchSearch(code);
  }

  @override
  Widget build(BuildContext context) {
    return StoreScaffold(
      currentTab: HomeTab.search,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            StoreHeader(
              action: StoreHeaderFilterAction(
                onTap: () => showProductSortSheet(
                  context,
                  current: _sort,
                  onSelected: (sort) => setState(() => _sort = sort),
                ),
              ),
              bottom: CustomSearchField(
                controller: _controller,
                autofocus: widget.initialQuery == null,
                onChanged: _onChanged,
                onClear: _onClear,
                suffix: IconButton(
                  icon: Icon(Icons.qr_code_scanner_rounded, size: 22.sp),
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.w, 40.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  color: AppColors.primaryColor,
                  onPressed: _onScanTap,
                ),
              ),
            ),
            Gap(16.h),
            StoreBreadcrumb(current: 'Search'.tr()),
            Expanded(
              // Builder: body context, so the bottom inset includes the nav.
              child: Builder(
                builder: (context) => _hasQuery
                    ? _buildResults(context)
                    : _SuggestedProducts(bloc: _suggestionsBloc),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    final padding = EdgeInsets.fromLTRB(
      16.w,
      16.h,
      16.w,
      MediaQuery.paddingOf(context).bottom + 40.h,
    );

    return BlocBuilder<ProductBloc, BaseState<ItemModel>>(
      builder: (context, state) {
        if (state.isLoading || state.isInitial) {
          return CategoryProductGridShimmer(padding: padding);
        }
        if (state.isFailure) {
          return FailureWidget(
            state: state,
            errorMessage: state.errorMessage ?? '',
            onRetry: () => _dispatchSearch(_controller.text),
          );
        }
        return CategoryProductsGrid(
          padding: padding,
          products: _sort.apply(
            state.items.map((item) => item.toProductMap()).toList(),
          ),
        );
      },
    );
  }
}

/// What the page shows before anything is typed: a short hint and a
/// shuffled grid of products to browse. Pull or "Shuffle" for a new pick.
class _SuggestedProducts extends StatelessWidget {
  const _SuggestedProducts({required this.bloc});

  final ProductBloc bloc;

  void _reload() => bloc.add(const GetSuggestedProductsEvent());

  @override
  Widget build(BuildContext context) {
    final gridPadding = EdgeInsets.symmetric(horizontal: 16.w);
    const gridPhysics = NeverScrollableScrollPhysics();

    return StorePullToRefresh(
      onRefresh: () {
        _reload();
        return untilLoaded(bloc);
      },
      builder: (controller) => SingleChildScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: 16.h,
          bottom: MediaQuery.paddingOf(context).bottom + 40.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SearchHint(),
            Gap(24.h),
            HomeSectionTitle(
              title: 'Suggested for you'.tr(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              actionLabel: 'Shuffle'.tr(),
              onAction: _reload,
            ),
            Gap(16.h),
            BlocBuilder<ProductBloc, BaseState<ItemModel>>(
              bloc: bloc,
              builder: (context, state) {
                if (state.isLoading || state.isInitial) {
                  return CategoryProductGridShimmer(
                    padding: gridPadding,
                    shrinkWrap: true,
                    physics: gridPhysics,
                  );
                }
                if (state.isFailure) {
                  return FailureWidget(
                    state: state,
                    errorMessage: state.errorMessage ?? '',
                    onRetry: _reload,
                  );
                }
                return CategoryProductsGrid(
                  padding: gridPadding,
                  shrinkWrap: true,
                  physics: gridPhysics,
                  products: state.items
                      .map((item) => item.toProductMap())
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        boxShadow: AppShadows.card(context),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.manage_search_rounded,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Looking for something?'.tr(),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                Gap(2.h),
                Text(
                  'Search by product name, category or barcode'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
