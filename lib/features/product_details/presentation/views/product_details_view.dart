import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/custom_snack_bar.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_action_bar.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_description_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_image_gallery.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_info_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_unit_card.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/similar_products_section.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.product});

  final Map<String, String> product;

  static const _whatsappNumber = '201026536149';

  Future<void> _openWhatsApp(BuildContext context) async {
    final whatsappUri = Uri.parse('https://wa.me/$_whatsappNumber');

    try {
      final launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        showCustomSnackBar(
          context,
          'Unable to open WhatsApp'.tr(),
          icon: Icons.error_outline,
          iconColor: Colors.redAccent,
        );
      }
    } catch (_) {
      if (context.mounted) {
        showCustomSnackBar(
          context,
          'Unable to open WhatsApp'.tr(),
          icon: Icons.error_outline,
          iconColor: Colors.redAccent,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId = int.tryParse(product['id'] ?? '') ?? 0;
    final images = (product['images'] ?? '')
        .split('|')
        .where((image) => image.isNotEmpty)
        .toList();
    final galleryImages = images.isNotEmpty ? images : [product['image'] ?? ''];

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
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.card.r),
                    boxShadow: AppShadows.card(context),
                  ),
                  child: ProductImageGallery(images: galleryImages),
                ),
              ),
              Gap(20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ProductInfoSection(name: product['name']!)),
                  FavoriteToggleButton(
                    productId: productId,
                    initialIsFavorite: product['isFavorite'] == 'true',
                    size: 24.sp,
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: ProductActionBar(
                      productId: productId,
                      barCode: product['barCode'] ?? '',
                      stockQuantity:
                          int.tryParse(product['quantity'] ?? '') ?? 0,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: _WhatsAppInquiryButton(
                      onPressed: () => _openWhatsApp(context),
                    ),
                  ),
                ],
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

class _WhatsAppInquiryButton extends StatelessWidget {
  const _WhatsAppInquiryButton({required this.onPressed});

  static const _whatsappGreen = Color(0xFF25D366);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: Material(
        color: _whatsappGreen,
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        elevation: 4,
        shadowColor: _whatsappGreen.withValues(alpha: 0.4),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill.r),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/whatsapp.svg',
                width: 20.sp,
                height: 20.sp,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              Gap(8.w),
              Flexible(
                child: Text(
                  'Send Inquiry'.tr(),
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
}
