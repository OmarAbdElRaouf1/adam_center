import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_events.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_event.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_product_card.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:the_one_test/features/product_details/presentation/views/product_details_view.dart';

const _favoritesTabIndex = 3;

void _addToCart(BuildContext context, Map<String, String> product) {
  final user = getIt<UserSessionCache>().getUser();
  context.read<AddToCartBloc>().add(
    AddToCart(
      AddToCartRequest(
        customerID: user?.customerId ?? 0,
        productID: int.tryParse(product['id'] ?? '') ?? 0,
        productBarcode: product['barCode'] ?? '',
      ),
    ),
  );
}

Map<String, String> _toProductMap(ItemModel item) {
  return {
    'id': item.productId.toString(),
    'barCode': item.barCode,
    'isFavorite': item.isFavorite.toString(),
    'image': item.productImage ?? '',
    'name': item.productArName,
    'description': item.description1 ?? '',
    'price': item.price.toString(),
    'categoryId': item.categoryId ?? '',
  };
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddToCartBloc>(create: (_) => getIt<AddToCartBloc>()),
        BlocProvider<FavoriteBloc>(
          create: (_) => getIt<FavoriteBloc>()..add(const FetchFavorites()),
        ),
      ],
      child: BlocListener<NavBarCubit, int>(
        listenWhen: (_, index) => index == _favoritesTabIndex,
        listener: (context, _) =>
            context.read<FavoriteBloc>().add(const FetchFavorites()),
        child: BlocListener<AddToCartBloc, BaseState<void>>(
          listener: (context, state) {
            if (state.isSuccess) {
              context.showSuccessMessage('Added to Cart'.tr());
            } else if (state.isFailure) {
              context.showErrorMessage(state.errorMessage ?? '');
            }
          },
          child: Scaffold(
            key: ValueKey(context.locale.languageCode),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Favorites'.tr(),
                        style: AppTextTheme.titleLargeBold.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Gap(10.h),

                  Expanded(
                    child: BlocBuilder<FavoriteBloc, BaseState<ItemModel>>(
                      builder: (context, state) {
                        if (state.isLoading || state.isInitial) {
                          return const ListRowShimmer(itemCount: 3);
                        }
                        if (state.isFailure) {
                          return FailureWidget(
                            state: state,
                            errorMessage: state.errorMessage ?? '',
                            onRetry: () => context.read<FavoriteBloc>().add(
                              const FetchFavorites(),
                            ),
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
                            final product = _toProductMap(state.items[index]);
                            return FavoriteProductCard(
                              product: product,
                              onDetailsTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailsView(product: product),
                                ),
                              ),
                              onAddTap: () => _addToCart(context, product),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
