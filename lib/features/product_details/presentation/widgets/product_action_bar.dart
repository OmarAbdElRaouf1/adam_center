import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/custom_snack_bar.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/views/cart_view.dart';

void _showAddedToCartSnackBar(BuildContext context) {
  showCustomSnackBar(
    context,
    'Added to Cart'.tr(),
    actionLabel: 'View Cart'.tr(),
    onActionPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartView()),
    ),
  );
}

class ProductActionBar extends StatelessWidget {
  const ProductActionBar({
    super.key,
    required this.productId,
    required this.barCode,
    required this.stockQuantity,
  });

  final int productId;
  final String barCode;
  final int stockQuantity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, BaseState<CartItemModel>>(
      bloc: getIt<CartBloc>(),
      builder: (context, state) {
        final index = state.items.indexWhere(
          (item) => item.productID == productId,
        );
        final quantity = index >= 0 ? state.items[index].salesQuantity : 0;
        final isLoading =
            state.isLoading && state.metadata['productId'] == productId;
        final atStockLimit = quantity >= stockQuantity;

        if (quantity == 0) {
          return SizedBox(
            width: double.infinity,
            height: 52.h,
            child: Material(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(AppRadius.pill.r),
              elevation: 4,
              shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill.r),
                onTap: isLoading
                    ? null
                    : () {
                        if (stockQuantity <= 0) {
                          showCustomSnackBar(
                            context,
                            'Out of Stock'.tr(),
                            icon: Icons.error_outline,
                            iconColor: Colors.redAccent,
                          );
                          return;
                        }
                        getIt<CartBloc>().add(
                          IncrementItem(productId, barCode),
                        );
                        _showAddedToCartSnackBar(context);
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      SizedBox(
                        width: 18.sp,
                        height: 18.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    Gap(8.w),
                    Flexible(
                      child: Text(
                        'Add to Cart'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Container(
          width: double.infinity,
          height: 52.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(AppRadius.pill.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () =>
                    getIt<CartBloc>().add(DeleteCartItem(productId, barCode)),
                icon: const Icon(Icons.remove, color: Colors.white),
              ),
              Text(
                context.localizeDigits('$quantity'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (atStockLimit) {
                    showCustomSnackBar(
                      context,
                      'Maximum available stock reached'.tr(),
                      icon: Icons.info_outline,
                      iconColor: Colors.amber,
                    );
                    return;
                  }
                  getIt<CartBloc>().add(IncrementItem(productId, barCode));
                  _showAddedToCartSnackBar(context);
                },
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
