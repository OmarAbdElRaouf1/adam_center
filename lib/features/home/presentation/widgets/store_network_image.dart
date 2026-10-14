import 'package:the_one_test/core/helper/helper.dart';

/// Network image without a disk cache, so an image replaced on the server
/// under the same URL shows up fresh. [placeholder] is shown while loading
/// and if the image fails (same look, so nothing flashes in between).
class StoreNetworkImage extends StatelessWidget {
  const StoreNetworkImage({
    super.key,
    required this.url,
    required this.placeholder,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String url;
  final Widget placeholder;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return placeholder;

    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      // Keep the old frame while a carousel page rebuilds instead of
      // blinking back to the placeholder.
      gaplessPlayback: true,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : placeholder,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}
