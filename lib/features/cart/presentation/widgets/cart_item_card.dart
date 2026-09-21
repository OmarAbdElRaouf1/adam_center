import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/custom_snack_bar.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';

import 'cart_quantity_stepper.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(color: AppColors.primaryColor, width: 1.6.w),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        children: [
          Text(
            context.localizeDigits(item.productName),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localizeDigits(
                        '${'Price'.tr()}: ${item.price.toStringAsFixed(0)} جنيه',
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      context.localizeDigits(
                        '${'Total'.tr()}: ${item.total.toStringAsFixed(0)} جنيه',
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              CartQuantityStepper(
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
              Gap(12.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  item.productImage,
                  width: 60.w,
                  height: 60.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 60.w,
                    height: 60.w,
                    color: Colors.grey.shade100,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
