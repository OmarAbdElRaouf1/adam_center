import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';

class MenuContactFab extends StatefulWidget {
  const MenuContactFab({super.key});

  @override
  State<MenuContactFab> createState() => _MenuContactFabState();
}

class _MenuContactFabState extends State<MenuContactFab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_expanded) ...[
          SubActionButton(
            icon: Icons.phone,
            color: AppColors.primaryColor,
            onTap: () {},
          ),
          Gap(10.h),
          SubActionButton(
            icon: Icons.message_outlined,
            color: Colors.green,
            onTap: () {},
          ),
          Gap(10.h),
        ],
        Material(
          color: AppColors.primaryColor,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Icon(
                _expanded ? Icons.close : Icons.chat_bubble_outline,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubActionButton extends StatelessWidget {
  const SubActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(11.w),
          child: Icon(icon, color: color, size: 18.sp),
        ),
      ),
    );
  }
}
