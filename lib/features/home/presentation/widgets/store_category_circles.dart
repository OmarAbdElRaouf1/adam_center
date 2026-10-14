import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_network_image.dart';

class StoreCircleItemData {
  const StoreCircleItemData({required this.title, required this.image});

  final String title;
  final String image;
}

/// Horizontal row of round category thumbnails with their names underneath;
/// the selected one gets a ring in the brand color.
class StoreCategoryCircles extends StatelessWidget {
  const StoreCategoryCircles({
    super.key,
    required this.items,
    required this.onTap,
    this.selectedIndex,
    this.isLoading = false,
  });

  final List<StoreCircleItemData> items;
  final ValueChanged<int> onTap;
  final int? selectedIndex;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = (context.screenWidth * 0.24).clamp(80.0, 140.0);

    return SizedBox(
      height: size + 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: isLoading
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: isLoading ? 5 : items.length,
        separatorBuilder: (_, _) => Gap(18.w),
        itemBuilder: (context, index) {
          if (isLoading) {
            return Align(
              alignment: Alignment.topCenter,
              child: BlockShimmer(
                width: size,
                height: size,
                borderRadius: BorderRadius.circular(size),
              ),
            );
          }
          return StoreCategoryCircle(
            data: items[index],
            size: size,
            isSelected: index == selectedIndex,
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}

class StoreCategoryCircle extends StatelessWidget {
  const StoreCategoryCircle({
    super.key,
    required this.data,
    required this.size,
    this.isSelected = false,
    this.onTap,
    this.labelFontSize = 14,
    this.withRing = true,
  });

  final StoreCircleItemData data;
  final double size;
  final bool isSelected;
  final VoidCallback? onTap;
  final double labelFontSize;

  /// Reserves the selection ring around the photo; off where nothing is
  /// ever selected (Home), so the photo fills the whole [size].
  final bool withRing;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.primaryColor.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size,
              height: size,
              padding: EdgeInsets.all(withRing ? 3.w : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: withRing
                    ? Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        width: 2.w,
                      )
                    : null,
              ),
              child: ClipOval(
                child: StoreNetworkImage(
                  url: data.image,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: placeholder,
                ),
              ),
            ),
            Gap(10.h),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: labelFontSize.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
