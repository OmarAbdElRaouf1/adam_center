import 'package:flutter/material.dart';

import 'flexible_image.dart';

/// Full-screen, pinch-to-zoom viewer for a single image. Meant to be pushed
/// on top of a thumbnail that shares the same [heroTag] for a smooth
/// fly-out transition.
class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer({
    super.key,
    required this.source,
    required this.heroTag,
  });

  final String source;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            constrained: false,
            panEnabled: true,
            scaleEnabled: true,
            minScale: 1,
            maxScale: 5,
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Center(
                child: Hero(
                  tag: heroTag,
                  child: FlexibleImage(source: source, fit: BoxFit.contain),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
