import 'package:the_one_test/core/helper/helper.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({super.key, required this.images});

  final List<String> images;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullScreen(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImageGallery(
          images: widget.images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleImages = widget.images.length > 1;

    return Column(
      children: [
        SizedBox(
          height: (context.screenHeight * 0.3).clamp(220.0, 420.0),
          width: double.infinity,
          child: hasMultipleImages
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _openFullScreen(index),
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                        size: 48.sp,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => _openFullScreen(0),
                  child: Image.network(
                    widget.images.first,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 48.sp,
                    ),
                  ),
                ),
        ),
        if (hasMultipleImages) ...[
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: _currentPage == index ? 16.w : 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primaryColor
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FullScreenImageGallery extends StatefulWidget {
  const _FullScreenImageGallery({
    required this.images,
    required this.initialIndex,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<_FullScreenImageGallery> createState() =>
      _FullScreenImageGalleryState();
}

class _FullScreenImageGalleryState extends State<_FullScreenImageGallery> {
  late final _pageController = PageController(initialPage: widget.initialIndex);
  late int _currentPage = widget.initialIndex;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleImages = widget.images.length > 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 48.sp,
                  ),
                ),
              ),
            ),
          ),
          if (hasMultipleImages)
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: _currentPage == index ? 16.w : 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primaryColor
                          : Colors.white38,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
