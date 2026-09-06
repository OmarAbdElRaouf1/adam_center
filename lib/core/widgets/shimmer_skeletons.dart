import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';
import '../extension/context_extension.dart';
import 'custom_shimmer.dart';

/// Skeleton matching [EnhancedProductItem]'s shape: image block, two text
/// lines, a price line and a small button-shaped block.
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.codGray : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmerWidget(
            //height: 132,
            width: double.infinity,
            shape: BoxShape.rectangle,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomShimmerWidget(height: 12, width: double.infinity),
                SizedBox(height: 6.h),
                CustomShimmerWidget(height: 12, width: 80.w),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomShimmerWidget(height: 18, width: 60.w),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: CustomShimmerWidget(height: 32, width: 64.w),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Staggered 2-column grid of [ProductCardShimmer], matching the real
/// product grids' brick/masonry layout.
class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final leftCount = (itemCount / 2).ceil();
    final rightCount = itemCount - leftCount;
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < leftCount; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: const ProductCardShimmer(),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 28.h),
                for (var i = 0; i < rightCount; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: const ProductCardShimmer(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal row of [ProductCardShimmer], for horizontal product carousels.
class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({super.key, this.itemCount = 4, this.height});

  final int itemCount;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 270.h,
      child: ListView.separated(
        padding: EdgeInsets.all(8.w),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) =>
            SizedBox(width: 150.w, child: const ProductCardShimmer()),
      ),
    );
  }
}

/// Generic list-row skeleton (leading thumbnail + a couple of text lines),
/// used for order lists, basket items, saved addresses, etc.
class ListRowShimmer extends StatelessWidget {
  const ListRowShimmer({super.key, this.itemCount = 4, this.rowHeight});

  final int itemCount;
  final double? rowHeight;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Column(
      children: [
        for (var i = 0; i < itemCount; i++)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            padding: EdgeInsets.all(12.w),
            height: rowHeight,
            decoration: BoxDecoration(
              color: isDark ? AppColors.codGray : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                CustomShimmerWidget(height: 70.h, width: 70.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomShimmerWidget(
                        height: 12,
                        width: double.infinity,
                      ),
                      SizedBox(height: 8.h),
                      CustomShimmerWidget(height: 12, width: 120.w),
                      SizedBox(height: 8.h),
                      CustomShimmerWidget(height: 12, width: 80.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Skeleton matching [CategoriesListViewItem]'s shape: a square/rounded
/// image block with a short centered label beneath.
class CategoryTileShimmer extends StatelessWidget {
  const CategoryTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CustomShimmerWidget(width: double.infinity, height: null),
        ),
        SizedBox(height: 6.h),
        CustomShimmerWidget(height: 10, width: 44.w),
      ],
    );
  }
}

/// Skeleton matching [CategoryRailItem]'s shape: a circular image with a
/// short label beneath, for the horizontal category rail.
class CategoryRailShimmer extends StatelessWidget {
  const CategoryRailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomShimmerWidget(height: 40.w, width: 40.w, shape: BoxShape.circle),
          SizedBox(height: 6.h),
          CustomShimmerWidget(height: 9, width: 32.w),
        ],
      ),
    );
  }
}

/// Single generic rectangular block, for banners/carousels/simple sections
/// that don't fit the other skeleton shapes.
class BlockShimmer extends StatelessWidget {
  const BlockShimmer({
    super.key,
    this.height = 100,
    this.width,
    this.margin,
    this.borderRadius,
  });

  final double height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: CustomShimmerWidget(height: height, width: width),
      ),
    );
  }
}
