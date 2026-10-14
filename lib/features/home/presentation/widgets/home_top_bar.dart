import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_logo.dart';
import 'package:the_one_test/features/auth/presentation/widgets/custom_search_field.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key, this.onSearchTap, this.onScanTap});

  final VoidCallback? onSearchTap;
  final VoidCallback? onScanTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w, bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 52.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                StoreLogo(size: 50.h),
                PositionedDirectional(
                  start: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24.r),
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Icon(
                      Icons.menu_rounded,
                      color: AppColors.primaryColor,
                      size: 32.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Gap(10.h),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.badge.r),
              boxShadow: AppShadows.card(context),
            ),
            child: CustomSearchField(
              readOnly: true,
              onTap: onSearchTap,
              fillColor: Theme.of(context).colorScheme.surface,
              suffix: IconButton(
                icon: Icon(Icons.qr_code_scanner_rounded, size: 18.sp),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  minimumSize: Size(36.w, 32.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                color: AppColors.primaryColor,
                onPressed: onScanTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
