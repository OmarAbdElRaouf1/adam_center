import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/views/checkout_view.dart';

/// White sheet pinned to the bottom of the cart: total and the checkout
/// button.
class CartCheckoutBar extends StatelessWidget {
  const CartCheckoutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, BaseState<CartItemModel>>(
      bloc: getIt<CartBloc>(),
      builder: (context, state) {
        final items = state.items;
        final subtotal = items.subtotal;

        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: AppShadows.raised(context),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'Grand Total'.tr()}:',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    Text(
                      context.localizeDigits(
                        '${subtotal.toStringAsFixed(0)} ${'EGP'.tr()}',
                      ),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
                Gap(18.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: FilledButton(
                    onPressed: items.isEmpty
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutView(subtotal: subtotal),
                            ),
                          ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.withValues(
                        alpha: 0.75,
                      ),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.chip.r),
                      ),
                    ),
                    child: Text(
                      'Complete Order'.tr(),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
