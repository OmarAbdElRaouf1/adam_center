import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/cart/data/models/add_to_cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_events.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_action_bar.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_description_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_image_gallery.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_info_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/similar_products_section.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.product});

  final Map<String, String> product;

  void _addToCart(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddToCartBloc>(create: (_) => getIt<AddToCartBloc>()),
        BlocProvider<FavoriteBloc>(create: (_) => getIt<FavoriteBloc>()),
      ],
      child: BlocListener<AddToCartBloc, BaseState<void>>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.showTopSnackBar(
              child: Text(
                'Added to Cart'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primaryColor,
            );
          } else if (state.isFailure) {
            context.showErrorMessage(state.errorMessage ?? '');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductImageGallery(images: [product['image']!]),
                      ),
                    ),
                    child: ProductImageGallery(images: [product['image']!]),
                  ),
                  Gap(20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ProductInfoSection(
                          name: product['name']!,
                          price: product['price']!,
                        ),
                      ),
                      FavoriteToggleButton(
                        productId: int.tryParse(product['id'] ?? '') ?? 0,
                        initialIsFavorite: product['isFavorite'] == 'true',
                        size: 24,
                      ),
                    ],
                  ),
                  Gap(16.h),
                  BlocBuilder<AddToCartBloc, BaseState<void>>(
                    builder: (context, state) {
                      return ProductActionBar(
                        onAddToCart: state.isLoading
                            ? () {}
                            : () => _addToCart(context),
                        isLoading: state.isLoading,
                      );
                    },
                  ),
                  Gap(20.h),
                  const Divider(),
                  Gap(10.h),
                  ProductDescriptionSection(
                    description: product['description']!,
                  ),
                  Gap(24.h),
                  SimilarProductsSection(
                    excludeName: product['name']!,
                    categoryId: int.tryParse(product['categoryId'] ?? ''),
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
