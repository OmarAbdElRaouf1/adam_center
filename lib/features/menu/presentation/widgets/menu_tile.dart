import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.card.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(context.screenWidth * 0.025),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card.r),
            boxShadow: AppShadows.card(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.screenWidth * 0.12,
                height: context.screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(AppRadius.badge.r),
                ),
                child: Icon(icon, color: Colors.white, size: 24.sp),
              ),
              Gap(8.h),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
