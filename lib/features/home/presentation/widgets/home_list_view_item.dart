import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_network_image.dart';

/// Product card: swipeable image with page dots, a heart in the corner,
/// two-line name, price and a full-width "View" button.
class HomeListViewItem extends StatelessWidget {
  const HomeListViewItem({super.key, required this.product, this.onTap});

  final Map<String, String> product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final images = (product['images'] ?? '')
        .split('|')
        .where((image) => image.isNotEmpty)
        .toList();
    if (images.isEmpty) images.add(product['image'] ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.sheet.r),
          boxShadow: AppShadows.card(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.82,
                  child: _CardImages(images: images),
                ),
                PositionedDirectional(
                  top: 10.h,
                  end: 10.w,
                  child: FavoriteToggleButton(
                    productId: int.tryParse(product['id'] ?? '') ?? 0,
                    initialIsFavorite: product['isFavorite'] == 'true',
                  ),
                ),
              ],
            ),
            // Expanded + Spacer: the card is stretched to its row's tallest
            // card (see HomeListView / CategoryProductsGrid), so price and
            // button sit on the bottom edge and line up across the row no
            // matter how many lines the name takes.
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15.sp, height: 1.4),
                    ),
                    Gap(10.h),
                    const Spacer(),
                    ProductPriceText(product: product, fontSize: 18),
                    Gap(12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 38.h,
                      child: FilledButton(
                        onPressed: onTap,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor.withValues(
                            alpha: 0.75,
                          ),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'View'.tr(),
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
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

/// Current price, with the original struck through next to it when the
/// product is discounted.
class ProductPriceText extends StatelessWidget {
  const ProductPriceText({
    super.key,
    required this.product,
    this.fontSize = 18,
  });

  final Map<String, String> product;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(product['price'] ?? '') ?? 0;
    final discounted =
        double.tryParse(product['priceAfterDiscount'] ?? '') ?? 0;
    final hasDiscount = discounted > 0 && discounted < price;
    String format(double value) =>
        context.localizeDigits(value.toStringAsFixed(0));

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 6.w,
      children: [
        Text(
          '${format(hasDiscount ? discounted : price)} ${'EGP'.tr()}',
          style: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        if (hasDiscount)
          Text(
            format(price),
            style: TextStyle(
              fontSize: (fontSize * 0.65).sp,
              color: Colors.grey.shade500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}

class _CardImages extends StatefulWidget {
  const _CardImages({required this.images});

  final List<String> images;

  @override
  State<_CardImages> createState() => _CardImagesState();
}

class _CardImagesState extends State<_CardImages> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Widget image(String url) => StoreNetworkImage(
      url: url,
      placeholder: Container(
        color: AppColors.primaryColor.withValues(alpha: 0.06),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.primaryColor.withValues(alpha: 0.4),
        ),
      ),
    );

    if (widget.images.length == 1) return image(widget.images.first);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (index) => setState(() => _current = index),
          itemBuilder: (_, index) => image(widget.images[index]),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.images.length, (index) {
              final isActive = index == _current;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.white : Colors.transparent,
                  border: Border.all(color: Colors.white, width: 1.w),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
