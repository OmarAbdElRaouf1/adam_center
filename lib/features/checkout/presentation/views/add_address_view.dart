import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/auth/presentation/widgets/location_dropdowns.dart';
import 'package:the_one_test/features/checkout/data/datasource/add_address_datasource.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _formKey = GlobalKey<FormState>();
  final streetController = TextEditingController();
  final houseController = TextEditingController();
  final blockController = TextEditingController();
  final floorController = TextEditingController();
  final apartmentController = TextEditingController();
  final notesController = TextEditingController();

  GovernorateModel? _governorate;
  DistrictModel? _district;
  bool _isSaving = false;

  @override
  void dispose() {
    streetController.dispose();
    houseController.dispose();
    blockController.dispose();
    floorController.dispose();
    apartmentController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_governorate == null || _district == null) {
      context.showErrorMessage('Please select governorate and district'.tr());
      return;
    }

    setState(() => _isSaving = true);

    final fullAddress =
        '${'Governorate'.tr()}: ${_governorate!.name}  '
        '${'District'.tr()}: ${_district!.name}  '
        '${'Street'.tr()}: ${streetController.text}  '
        '${'House'.tr()}: ${houseController.text}';

    final result = await getIt<AddAddressDatasource>().addAddress(
      governorateId: _governorate!.id,
      areaId: _district!.id,
      districtName: _district!.name,
      street: streetController.text,
      houseNumber: houseController.text,
      block: blockController.text.isEmpty ? null : blockController.text,
      floor: floorController.text.isEmpty ? null : floorController.text,
      apartment: apartmentController.text.isEmpty
          ? null
          : apartmentController.text,
      notes: notesController.text.isEmpty ? null : notesController.text,
      fullAddress: fullAddress,
      isMainAddress: true,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!result.isSuccess) {
      context.showErrorMessage(result.throwError().message);
      return;
    }

    // Re-fetch the address from the server rather than trusting what was
    // just sent, so the cached value matches what the backend actually
    // stored (e.g. any normalization it applies) instead of a client-side
    // reconstruction.
    final addressResult = await getIt<AddAddressDatasource>().getMainAddress();
    final address = addressResult.fold((_) => null, (address) => address);

    if (address != null) {
      final accountCubit = getIt<AccountCubit>();
      final currentUser = accountCubit.state;
      if (currentUser != null) {
        await accountCubit.updateUser(
          currentUser.copyWith(
            regionId: address['region_id'] as int?,
            regionName: address['RegionName'] as String?,
            districtName: address['DistrictName'] as String?,
            streetName: address['StreetName'] as String?,
            houseNo: address['HouseNo'] as String?,
            block: address['Block'] as String?,
            floor: address['Floor'] as String?,
            apartment: address['Apartment'] as String?,
            addressNotes: address['AddressNotes'] as String?,
            customerAddress: address['CustomerAddress'] as String?,
            addressId: address['AddressID']?.toString(),
          ),
        );
      }
    }

    if (!mounted) return;
    context.showSuccessMessage('Address added'.tr());
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titleText: 'Add Address'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationDropdowns(
                  onSelectionChanged: (governorate, district) {
                    setState(() {
                      _governorate = governorate;
                      _district = district;
                    });
                  },
                ),
                Gap(16.h),
                CustomTextFormField(
                  hintText: 'Street'.tr(),
                  controller: streetController,
                  validator: Validators.validateEmpty,
                  borderColor: AppColors.primaryColor,
                ),
                Gap(16.h),
                CustomTextFormField(
                  hintText: 'House Number'.tr(),
                  controller: houseController,
                  validator: Validators.validateEmpty,
                  borderColor: AppColors.primaryColor,
                ),
                Gap(16.h),
                CustomTextFormField(
                  hintText: 'Block'.tr(),
                  controller: blockController,
                  borderColor: AppColors.primaryColor,
                ),
                Gap(16.h),
                CustomTextFormField(
                  hintText: 'Floor'.tr(),
                  controller: floorController,
                  borderColor: AppColors.primaryColor,
                ),
                Gap(16.h),
                CustomTextFormField(
                  hintText: 'Apartment'.tr(),
                  controller: apartmentController,
                  borderColor: AppColors.primaryColor,
                ),
                Gap(16.h),
                CustomTextFormField(
                  hintText: 'Notes'.tr(),
                  controller: notesController,
                  borderColor: AppColors.primaryColor,
                ),
                Gap(28.h),
                CustomElevatedButton.filled(
                  context: context,
                  title: _isSaving ? '...'.tr() : 'Save Address'.tr(),
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: AppRadius.pill,
                  onPressed: _isSaving ? () {} : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
