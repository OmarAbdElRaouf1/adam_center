import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_action_bar.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_description_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_image_gallery.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_info_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/similar_products_section.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.product});

  final Map<String, String> product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ProductActionBar(
                productId: int.tryParse(product['id'] ?? '') ?? 0,
                barCode: product['barCode'] ?? '',
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
