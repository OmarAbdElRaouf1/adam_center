import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';

class ProductActionBar extends StatelessWidget {
  const ProductActionBar({
    super.key,
    required this.productId,
    required this.barCode,
  });

  final int productId;
  final String barCode;

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

        if (quantity == 0) {
          return Row(
            children: [
              Expanded(
                child: CustomElevatedButton.filled(
                  context: context,
                  title: 'Add to Cart'.tr(),
                  onPressed: isLoading
                      ? () {}
                      : () => getIt<CartBloc>().add(
                          IncrementItem(productId, barCode),
                        ),
                  isLoading: isLoading,
                  icon: Icons.shopping_bag_outlined,
                  borderRadius: AppRadius.pill,
                  width: context.screenWidth - 40.w,
                  height: 50.h,
                  fontSize: 14,
                ),
              ),
            ],
          );
        }

        return Container(
          width: context.screenWidth - 40.w,
          height: 50.h,
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
                onPressed: () =>
                    getIt<CartBloc>().add(IncrementItem(productId, barCode)),
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
