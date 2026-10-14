import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_network_image.dart';

class BannerSliderItem extends StatelessWidget {
  const BannerSliderItem({super.key, required this.banner});

  final Map<String, String> banner;

  @override
  Widget build(BuildContext context) {
    final title = banner['title'];
    final subtitle = banner['subtitle'];
    final hasText =
        (title?.isNotEmpty ?? false) || (subtitle?.isNotEmpty ?? false);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StoreNetworkImage(
            url: banner['image'] ?? '',
            placeholder: const _BannerPlaceholder(),
          ),
          if (hasText)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (title != null && title.isNotEmpty)
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    if (title != null && title.isNotEmpty) Gap(4.h),

                    if (subtitle != null && subtitle.isNotEmpty)
                      SizedBox(
                        width: 220.w,
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.primaryColor.withValues(alpha: 0.4),
        size: 32.sp,
      ),
    );
  }
}
