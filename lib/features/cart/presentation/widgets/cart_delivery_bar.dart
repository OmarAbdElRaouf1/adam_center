import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';

import 'delivery_address_bottom_sheet.dart';

class CartDeliveryBar extends StatefulWidget {
  const CartDeliveryBar({super.key});

  @override
  State<CartDeliveryBar> createState() => _CartDeliveryBarState();
}

class _CartDeliveryBarState extends State<CartDeliveryBar> {
  var user = getIt<UserSessionCache>().getUser();

  Future<void> _openAddressPicker(BuildContext context) async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet.r),
        ),
      ),
      builder: (_) => const DeliveryAddressBottomSheet(),
    );

    if (updated == true && mounted) {
      setState(() => user = getIt<UserSessionCache>().getUser());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        boxShadow: AppShadows.card(context),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'Deliver to'.tr()}: ${user?.regionName}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                Gap(2.h),
                Text(
                  '${user?.regionName}, ${user?.districtName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openAddressPicker(context),
            icon: Icon(Icons.chevron_left, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
