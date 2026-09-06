import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Cart'.tr(),
          style: AppTextTheme.titleLargeBold.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        // BlocBuilder<CartBloc, BaseState<CartItemModel>>(
        //   builder: (context, state) {
        //     if (state.items.isEmpty) return const SizedBox.shrink();
        //     return TextButton.icon(
        //       onPressed: () => context.read<CartBloc>().add(const ClearCart()),
        //       icon: Icon(
        //         Icons.delete_outline,
        //         color: AppColors.red,
        //         size: 18.sp,
        //       ),
        //       label: Text(
        //         'Clear Cart'.tr(),
        //         style: AppTextTheme.body2.copyWith(color: AppColors.red),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
