import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:the_one_test/core/extension/context_extension.dart';
import 'package:the_one_test/features/home/presentation/widgets/banner_slider_item.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key, required this.banners});

  final List<Map<String, String>> banners;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: (context.screenWidth * 0.45).clamp(140.0, 260.0),
        viewportFraction: 0.92,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOut,
        enableInfiniteScroll: true,
      ),
      items: banners.map((banner) {
        return Builder(
          builder: (context) {
            return BannerSliderItem(banner: banner);
          },
        );
      }).toList(),
    );
  }
}
