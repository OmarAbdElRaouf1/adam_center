import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/features/category_products/data/models/item_model_x.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_product_card.dart';
import 'package:the_one_test/features/product_details/presentation/views/product_details_view.dart';

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
      appBar: const CustomAppBar(titleText: 'Favorites'),
      body: SafeArea(
        child: Column(
          children: [
            Gap(10.h),
            Expanded(
              child: BlocBuilder<FavoriteBloc, BaseState<ItemModel>>(
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
                    return EmptyStateWidget(
                      icon: Icons.favorite_border,
                      message: 'No favorites yet'.tr(),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) => Gap(14.h),
                    itemBuilder: (context, index) {
                      final product = state.items[index].toProductMap();
                      return FavoriteProductCard(
                        key: ValueKey(product['id']),
                        product: product,
                        onDetailsTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsView(product: product),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
