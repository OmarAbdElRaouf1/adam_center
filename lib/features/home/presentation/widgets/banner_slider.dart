import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_one_test/core/extension/context_extension.dart';
import 'package:the_one_test/features/home/presentation/widgets/banner_slider_item.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key, required this.banners});

  final List<Map<String, String>> banners;

  static double heightOf(BuildContext context) => context.screenWidth * 0.5;

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: BannerSlider.heightOf(context),
            viewportFraction: 1,
            autoPlay: widget.banners.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enableInfiniteScroll: widget.banners.length > 1,
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
          items: widget.banners
              .map((banner) => BannerSliderItem(banner: banner))
              .toList(),
        ),
        if (widget.banners.length > 1)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.banners.length, (index) {
                final isActive = index == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: isActive ? 1 : 0.5),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
