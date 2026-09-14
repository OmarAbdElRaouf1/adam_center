import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/custom_snack_bar.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_description_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_image_gallery.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_info_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_unit_card.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/similar_products_section.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.product});

  final Map<String, String> product;

  @override
  Widget build(BuildContext context) {
    final productId = int.tryParse(product['id'] ?? '') ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
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
                    child: ProductInfoSection(name: product['name']!),
                  ),
                  FavoriteToggleButton(
                    productId: productId,
                    initialIsFavorite: product['isFavorite'] == 'true',
                    size: 24,
                  ),
                ],
              ),
              Gap(16.h),
              CustomElevatedButton.filled(
                context: context,
                title: 'Send Inquiry'.tr(),
                onPressed: () => showCustomSnackBar(
                  context,
                  'Inquiry sent successfully'.tr(),
                ),
                icon: Icons.chat_bubble_outline,
                backgroundColor: const Color(0xFF25D366),
                borderRadius: AppRadius.pill,
                width: context.screenWidth - 40.w,
                height: 50.h,
                fontSize: 14,
              ),
              Gap(20.h),
              Text(
                'Choose Unit'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              Gap(10.h),
              ProductUnitCard(
                productId: productId,
                barCode: product['barCode'] ?? '',
                code: product['code'] ?? '',
                price: product['price'] ?? '',
                quantity: product['quantity'] ?? '',
              ),
              Gap(20.h),
              const Divider(),
              Gap(10.h),
              ProductDescriptionSection(description: product['description']!),
              Gap(24.h),
              SimilarProductsSection(
                excludeName: product['name']!,
                categoryId: int.tryParse(product['categoryId'] ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
