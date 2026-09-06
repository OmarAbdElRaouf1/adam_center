import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';

class ProductActionBar extends StatelessWidget {
  const ProductActionBar({
    super.key,
    required this.onAddToCart,
    this.isLoading = false,
  });

  final VoidCallback onAddToCart;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton.filled(
            context: context,
            title: 'Add to Cart'.tr(),
            onPressed: onAddToCart,
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
}
