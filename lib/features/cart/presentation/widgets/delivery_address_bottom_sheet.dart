import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/auth/presentation/widgets/location_dropdowns.dart';

class DeliveryAddressBottomSheet extends StatefulWidget {
  const DeliveryAddressBottomSheet({super.key});

  @override
  State<DeliveryAddressBottomSheet> createState() =>
      _DeliveryAddressBottomSheetState();
}

class _DeliveryAddressBottomSheetState
    extends State<DeliveryAddressBottomSheet> {
  GovernorateModel? _selectedGovernorate;
  DistrictModel? _selectedDistrict;

  void _save() {
    if (_selectedGovernorate == null || _selectedDistrict == null) {
      context.showErrorMessage('Please select governorate and district'.tr());
      return;
    }

    final cache = getIt<UserSessionCache>();
    final user = cache.getUser();
    if (user == null) {
      Navigator.pop(context);
      return;
    }

    cache.saveUser(
      user.copyWith(
        regionId: _selectedGovernorate!.id,
        regionName: _selectedGovernorate!.name,
        districtName: _selectedDistrict!.name,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
            ),
          ),
          Gap(16.h),
          Text(
            'Delivery Address'.tr(),
            style: AppTextTheme.titleLargeBold.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Gap(16.h),
          LocationDropdowns(
            onSelectionChanged: (governorate, district) => setState(() {
              _selectedGovernorate = governorate;
              _selectedDistrict = district;
            }),
          ),
          Gap(24.h),
          CustomElevatedButton.filled(
            context: context,
            title: 'Save Address'.tr(),
            onPressed: _save,
            backgroundColor: AppColors.primaryColor,
            borderRadius: AppRadius.pill,
            width: context.screenWidth - 40.w,
          ),
        ],
      ),
    );
  }
}
