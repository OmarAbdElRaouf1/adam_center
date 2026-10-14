import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/custom_snack_bar.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';

import 'cart_quantity_stepper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_network_image.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final imageSize = 96.w;
    final placeholder = Container(
      color: AppColors.primaryColor.withValues(alpha: 0.06),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.badge.r),
            child: SizedBox.square(
              dimension: imageSize,
              child: StoreNetworkImage(
                url: item.productImage,
                placeholder: placeholder,
              ),
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localizeDigits(item.productName),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.sp),
                ),
                Gap(8.h),
                Text(
                  context.localizeDigits(
                    '${item.price.toStringAsFixed(0)} ${'EGP'.tr()}',
                  ),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.primaryColor.withValues(alpha: 0.75),
                  ),
                ),
                Gap(10.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: CartQuantityStepper(
                    quantity: item.salesQuantity,
                    onIncrement: () {
                      if (item.salesQuantity >= item.stockQuantity) {
                        showCustomSnackBar(
                          context,
                          'Maximum available stock reached'.tr(),
                          icon: Icons.info_outline,
                          iconColor: Colors.amber,
                        );
                        return;
                      }
                      getIt<CartBloc>().add(
                        IncrementItem(item.productID, item.barCode),
                      );
                    },
                    onDecrement: () => getIt<CartBloc>().add(
                      DeleteCartItem(item.productID, item.barCode),
                    ),
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
