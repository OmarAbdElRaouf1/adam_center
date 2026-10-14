import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_chat_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_breadcrumb.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_pull_to_refresh.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    getIt<FavoriteBloc>().add(const FetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.languageCode),
      floatingActionButton: const HomeChatButton(),
      body: Column(
        children: [
          const StoreHeader(showMenu: false),
          Gap(28.h),
          StoreBreadcrumb(current: 'Favorites'.tr()),
          Expanded(
            child: StorePullToRefresh(
              onRefresh: () {
                final bloc = getIt<FavoriteBloc>()..add(const FetchFavorites());
                return untilLoaded(bloc);
              },
              builder: (controller) =>
                  BlocBuilder<FavoriteBloc, BaseState<ItemModel>>(
                    bloc: getIt<FavoriteBloc>(),
                    builder: (context, state) {
                      // if (state.isLoading || state.isInitial) {
                      //   return const ListRowShimmer(itemCount: 3);
                      // }
                      if (state.isFailure) {
                        return FailureWidget(
                          state: state,
                          errorMessage: state.errorMessage ?? '',
                          onRetry: () =>
                              getIt<FavoriteBloc>().add(const FetchFavorites()),
                        );
                      }
                      if (state.items.isEmpty) {
                        return ListView(
                          controller: controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [_EmptyFavorites()],
                        );
                      }

                      return CategoryProductsGrid(
                        controller: controller,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 100.h),
                        products: state.items
                            .map((item) => item.toProductMap())
                            .toList(),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 0),
      child: Column(
        children: [
          Text(
            'No favorites yet'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor.withValues(alpha: 0.75),
            ),
          ),
          Gap(16.h),
          Text(
            'Add products to your favorites to see them here'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700),
          ),
          Gap(24.h),
          FilledButton(
            onPressed: () => popToStoreRoot(context),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.75),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.chip.r),
              ),
            ),
            child: Text('Go to Store'.tr(), style: TextStyle(fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }
}
