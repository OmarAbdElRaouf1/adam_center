import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_events.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view_item.dart';
import 'package:the_one_test/features/product_details/presentation/views/product_details_view.dart';

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

class MoreProductsGridView extends StatelessWidget {
  const MoreProductsGridView({super.key, required this.title, this.products});

  final String title;
  final List<Map<String, String>>? products;

  @override
  Widget build(BuildContext context) {
    final products = this.products ?? const <Map<String, String>>[];

    return MultiBlocProvider(
      providers: [
        BlocProvider<AddToCartBloc>(create: (_) => getIt<AddToCartBloc>()),
        BlocProvider<FavoriteBloc>(create: (_) => getIt<FavoriteBloc>()),
      ],
      child: BlocListener<AddToCartBloc, BaseState<void>>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.showSuccessMessage('Added to Cart'.tr());
          } else if (state.isFailure) {
            context.showErrorMessage(state.errorMessage ?? '');
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Gap(16.w),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),

                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),

                    // مساحة فاضية بنفس عرض الزرار عشان العنوان يبقى في النص بالظبط
                    Gap(48.w),
                  ],
                ),

                Gap(20.h),

                Expanded(
                  child: products.isEmpty
                      ? EmptyStateWidget(message: 'No products yet'.tr())
                      : GridView.builder(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                            top: 8.h,
                            bottom: 110.h,
                          ),
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14.w,
                                mainAxisSpacing: 14.h,
                                childAspectRatio: 0.68,
                              ),
                          itemBuilder: (context, index) {
                            final product = products[index];

                            return HomeListViewItem(
                              product: product,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailsView(product: product),
                                ),
                              ),
                              onAddTap: () => _addToCart(context, product),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
