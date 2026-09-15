import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/core/widgets/widgets/custom_text_field.dart';
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/auth/presentation/widgets/location_dropdowns.dart';
import 'package:the_one_test/features/checkout/presentation/manager/add_address_bloc/add_address_bloc.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddAddressBloc>(),
      child: const _AddAddressForm(),
    );
  }
}

class _AddAddressForm extends StatefulWidget {
  const _AddAddressForm();

  @override
  State<_AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends State<_AddAddressForm> {
  final _formKey = GlobalKey<FormState>();
  final streetController = TextEditingController();
  final houseController = TextEditingController();
  final blockController = TextEditingController();
  final floorController = TextEditingController();
  final apartmentController = TextEditingController();
  final notesController = TextEditingController();

  GovernorateModel? _governorate;
  DistrictModel? _district;

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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_governorate == null || _district == null) {
      context.showErrorMessage('Please select governorate and district'.tr());
      return;
    }

    final fullAddress =
        '${'Governorate'.tr()}: ${_governorate!.name}  '
        '${'District'.tr()}: ${_district!.name}  '
        '${'Street'.tr()}: ${streetController.text}  '
        '${'House'.tr()}: ${houseController.text}';

    context.read<AddAddressBloc>().add(
      SaveAddress(
        governorateId: _governorate!.id,
        governorateName: _governorate!.name,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddAddressBloc, BaseState<void>>(
      listener: (context, state) {
        if (state.isSuccess) {
          context.showSuccessMessage('Address added'.tr());
          Navigator.pop(context, true);
        } else if (state.isFailure) {
          context.showErrorMessage(state.errorMessage ?? '');
        }
      },
      child: Scaffold(
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
                  BlocBuilder<AddAddressBloc, BaseState<void>>(
                    builder: (context, state) {
                      final isSaving = state.isLoading;
                      return CustomElevatedButton.filled(
                        context: context,
                        title: isSaving ? '...'.tr() : 'Save Address'.tr(),
                        backgroundColor: AppColors.primaryColor,
                        borderRadius: AppRadius.pill,
                        onPressed: isSaving ? () {} : _save,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
