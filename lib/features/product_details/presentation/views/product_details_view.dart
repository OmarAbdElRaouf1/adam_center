import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_chat_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view_item.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_section_title.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_action_bar.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_description_section.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/product_image_gallery.dart';
import 'package:the_one_test/features/product_details/presentation/widgets/similar_products_section.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.product});

  final Map<String, String> product;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final _scrollController = ScrollController();
  bool _showScrollTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 600;
      if (show != _showScrollTop) setState(() => _showScrollTop = show);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final productId = int.tryParse(product['id'] ?? '') ?? 0;
    final images = (product['images'] ?? '')
        .split('|')
        .where((image) => image.isNotEmpty)
        .toList();
    final galleryImages = images.isNotEmpty ? images : [product['image'] ?? ''];
    final color = product['color'] ?? '';
    final size = product['size'] ?? '';
    final stockQuantity = int.tryParse(product['quantity'] ?? '') ?? 0;

    return StoreScaffold(
      bottomNavigationBar: _BottomBar(
        child: ProductActionBar(
          productId: productId,
          barCode: product['barCode'] ?? '',
          stockQuantity: stockQuantity,
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: _showScrollTop ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: SizedBox.square(
              dimension: 56.w,
              child: FloatingActionButton(
                heroTag: null,
                elevation: 4,
                shape: const CircleBorder(),
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.85),
                foregroundColor: Colors.white,
                onPressed: () => _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
                child: Icon(Icons.arrow_upward_rounded, size: 28.sp),
              ),
            ),
          ),
          Gap(14.h),
          const HomeChatButton(),
        ],
      ),
      // Builder: the body's own context, whose MediaQuery bottom padding
      // includes the add-to-cart bar the page scrolls behind.
      body: Builder(
        builder: (context) => Column(
          children: [
            const StoreHeader(action: StoreHeaderCartAction()),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 40.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ProductImageGallery(images: galleryImages),
                        PositionedDirectional(
                          top: 16.h,
                          end: 16.w,
                          child: FavoriteToggleButton(
                            productId: productId,
                            initialIsFavorite: product['isFavorite'] == 'true',
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(20.h),
                          Text(
                            product['name'] ?? '',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap(14.h),
                          Text(
                            '${'SKU'.tr()}: ${product['code'] ?? ''}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Gap(12.h),
                          _StockBadge(quantity: stockQuantity),
                          Gap(18.h),
                          ProductDescriptionSection(
                            description: product['description'] ?? '',
                          ),
                          Gap(24.h),
                          ProductPriceText(product: product, fontSize: 30),
                        ],
                      ),
                    ),
                    if (color.isNotEmpty) ...[
                      Gap(24.h),
                      _OptionSection(title: 'Color'.tr(), value: color),
                    ],
                    if (size.isNotEmpty) ...[
                      Gap(24.h),
                      _OptionSection(title: 'Size'.tr(), value: size),
                    ],
                    Gap(36.h),
                    SimilarProductsSection(
                      excludeName: product['name'] ?? '',
                      categoryId: int.tryParse(product['categoryId'] ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// How many pieces are left in stock: green when available, orange when
/// running low and red when sold out.
class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.quantity});

  final int quantity;

  static const _lowStockThreshold = 5;

  @override
  Widget build(BuildContext context) {
    final count = context.localizeDigits(quantity.toString());
    final (color, icon, label) = switch (quantity) {
      <= 0 => (
        Colors.red.shade600,
        Icons.remove_shopping_cart_outlined,
        'Out of Stock'.tr(),
      ),
      <= _lowStockThreshold => (
        Colors.orange.shade700,
        Icons.hourglass_bottom_rounded,
        'Only {} left in stock'.tr(args: [count]),
      ),
      _ => (
        Colors.green.shade600,
        Icons.inventory_2_outlined,
        'In stock: {}'.tr(args: [count]),
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18.sp),
          Gap(6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title with a trailing line and the product's option (a product
/// here is a single variant, so its one value shows as selected).
class _OptionSection extends StatelessWidget {
  const _OptionSection({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitle(
          title: title,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        Gap(16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.badge.r),
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
            ),
            child: Text(
              value,
              style: TextStyle(fontSize: 16.sp, color: AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: AppShadows.raised(context),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
