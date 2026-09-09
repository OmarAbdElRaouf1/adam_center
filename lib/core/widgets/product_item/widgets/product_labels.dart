import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ribbon tag anchored to the top-right corner: flush against the top and
/// right edges, with the bottom-left curving inward like a flag tail.
class _RibbonTag extends StatelessWidget {
  const _RibbonTag({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: ClipPath(
        clipper: _RibbonClipper(),
        child: Container(
          color: color,
          padding: EdgeInsets.only(
            top: 5.h,
            bottom: 9.h,
            left: 8.w,
            right: 8.w,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..quadraticBezierTo(size.width * 0.3, size.height, 0, size.height * 0.55)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class OfferBadge extends StatelessWidget {
  const OfferBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return _RibbonTag(text: 'special_offer'.tr(), color: Colors.red);
  }
}

class OutOfStockBanner extends StatelessWidget {
  const OutOfStockBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return _RibbonTag(text: 'unavailable'.tr(), color: Colors.red);
  }
}
