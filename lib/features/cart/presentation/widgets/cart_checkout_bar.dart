import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/views/delivery_info_view.dart';

class CartCheckoutBar extends StatelessWidget {
  const CartCheckoutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, BaseState<CartItemModel>>(
      bloc: getIt<CartBloc>(),
      builder: (context, state) {
        final items = state.items;
        final subtotal = items.subtotal;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localizeDigits(
                      '${subtotal.toStringAsFixed(0)} جنيه',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    'Subtotal'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Gap(12.w),
            CustomElevatedButton.filled(
              context: context,
              title: 'Pay'.tr(),
              onPressed: items.isEmpty
                  ? () {}
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliveryInfoView(subtotal: subtotal),
                      ),
                    ),
              backgroundColor: items.isEmpty
                  ? AppColors.primaryColor.withValues(alpha: 0.4)
                  : AppColors.primaryColor,
              borderRadius: AppRadius.pill,
              width: 150.w,
              height: 48.h,
              fontSize: 16.sp,
            ),
          ],
        );
      },
    );
  }
}
