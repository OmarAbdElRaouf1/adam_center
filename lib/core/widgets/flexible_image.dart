import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_one_test/core/extension/context_extension.dart';

import '../constant/app_assets.dart';
import 'custom_shimmer.dart';

class FlexibleImage extends StatelessWidget {
  final dynamic source;
  final BorderRadiusGeometry borderRadius;
  final bool isCircular;
  final Widget? placeholder;
  final String? fallbackImage;
  final double? width;
  final double? height;
  final BoxFit? fit;

  // List of fallback images
  static const List<String> _fallbackImages = [
    AppAssets.fallBackBanner1,
    AppAssets.fallBackBanner2,
    AppAssets.fallBackBanner3,
    AppAssets.fallBackBanner4,
    AppAssets.fallBackBanner5,
    AppAssets.fallBackBanner6,
    AppAssets.fallBackBanner7,
  ];

  const FlexibleImage({
    super.key,
    required this.source,
    this.borderRadius = BorderRadius.zero,
    this.isCircular = false,
    this.placeholder,
    this.fallbackImage,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  bool _isNetworkImage(String path) {
    return Uri.tryParse(path)?.hasAbsolutePath ?? false;
  }

  bool _isFileImage(String path) {
    return File(path).existsSync();
  }

  bool _isMemoryImage(dynamic data) {
    return data is Uint8List;
  }

  // Get a random fallback image
  String _getRandomFallbackImage() {
    final random = Random();
    return _fallbackImages[random.nextInt(_fallbackImages.length)];
  }

  Widget _defaultErrorImage(BuildContext context) {
    final cleanFallback = fallbackImage?.trim();
    if (cleanFallback != null &&
        cleanFallback.isNotEmpty &&
        cleanFallback != 'null' &&
        cleanFallback != 'undefined') {
      if (_isNetworkImage(cleanFallback)) {
        return CachedNetworkImage(
          imageUrl: cleanFallback,
          width: width,
          height: height,
          fit: fit,
          errorWidget: (context, url, error) => _randomFallbackWidget(context),
        );
      } else {
        return Image.asset(
          cleanFallback,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              _randomFallbackWidget(context),
        );
      }
    }
    return _randomFallbackWidget(context);
  }

  Widget _randomFallbackWidget(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: context.colorScheme.secondary.withValues(alpha: 0.1),
      child: Image.asset(_getRandomFallbackImage(), fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    try {
      final cleanSource = source is String ? source.trim() : source;

      if (cleanSource == null ||
          (cleanSource is String &&
              (cleanSource.isEmpty ||
                  cleanSource == 'null' ||
                  cleanSource == 'undefined'))) {
        imageWidget = _defaultErrorImage(context);
      } else if (cleanSource is String) {
        if (_isFileImage(cleanSource)) {
          imageWidget = Image.file(
            File(cleanSource),
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _defaultErrorImage(context),
          );
        } else if (_isNetworkImage(cleanSource)) {
          imageWidget = CachedNetworkImage(
            imageUrl: cleanSource,
            placeholder: (context, url) =>
                placeholder ??
                Center(child: CustomShimmerWidget(height: height)),
            errorWidget: (context, url, error) => _defaultErrorImage(context),
            fit: fit,
          );
        } else {
          imageWidget = Image.asset(
            cleanSource,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _defaultErrorImage(context),
          );
        }
      } else if (_isMemoryImage(cleanSource)) {
        imageWidget = Image.memory(
          cleanSource,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              _defaultErrorImage(context),
        );
      } else {
        imageWidget = _defaultErrorImage(context);
      }
    } catch (_) {
      imageWidget = _defaultErrorImage(context);
    }

    return ClipRRect(
      borderRadius: isCircular ? BorderRadius.circular(1000) : borderRadius,
      child: SizedBox(width: width, height: height, child: imageWidget),
    );
  }
}
