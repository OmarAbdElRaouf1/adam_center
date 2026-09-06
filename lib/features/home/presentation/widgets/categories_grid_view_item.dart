import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class CategoriesListViewItem extends StatelessWidget {
  const CategoriesListViewItem({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
  });

  final String title;
  final String image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.badge),
                child: Image.network(
                  image,
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                    color: AppColors.primaryColor.withValues(alpha: 0.08),
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.primaryColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),

              Gap(6.h),
              Text(
                title.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextTheme.labelMedium11Bold.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
