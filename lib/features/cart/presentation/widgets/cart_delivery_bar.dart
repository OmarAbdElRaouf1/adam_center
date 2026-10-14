import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';

/// Info line under the cart items: the delivery address, or a prompt to add
/// one. Tapping it opens the address picker.
class CartDeliveryBar extends StatelessWidget {
  const CartDeliveryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChooseAddressView()),
      ),
      // AccountCubit is a shared, app-wide singleton — reading it here via
      // `bloc:` means an address change made anywhere else shows up here
      // immediately too.
      child: BlocBuilder<AccountCubit, UserModel?>(
        bloc: getIt<AccountCubit>(),
        builder: (context, user) {
          final location = [
            user?.regionName,
            user?.districtName,
          ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
          final label = location.isEmpty
              ? 'Add your address to calculate shipping'.tr()
              : '${'Deliver to'.tr()}: $location';

          return Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 24.sp),
              Gap(10.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
