import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';
import 'package:the_one_test/features/checkout/data/models/delivery_info_model.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';
import 'package:the_one_test/features/checkout/presentation/views/payment_view.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/delivery_address_button.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/delivery_address_fields.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/delivery_contact_fields.dart';

class DeliveryInfoForm extends StatefulWidget {
  const DeliveryInfoForm({super.key, required this.subtotal});

  final double subtotal;

  @override
  State<DeliveryInfoForm> createState() => _DeliveryInfoFormState();
}

class _DeliveryInfoFormState extends State<DeliveryInfoForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final areaController = TextEditingController();
  final streetController = TextEditingController();
  final houseNumberController = TextEditingController();
  final fullAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hydrateFrom(getIt<AccountCubit>().state);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    areaController.dispose();
    streetController.dispose();
    houseNumberController.dispose();
    fullAddressController.dispose();
    super.dispose();
  }

  void _hydrateFrom(UserModel? user) {
    if (user == null) return;
    firstNameController.text = user.englishName ?? firstNameController.text;
    lastNameController.text = user.lastName ?? lastNameController.text;
    phoneController.text = user.customerPhone.isNotEmpty
        ? user.customerPhone
        : phoneController.text;
    emailController.text = user.email ?? emailController.text;
    areaController.text =
        districtFromCustomerAddress(user.customerAddress) ??
        user.districtName ??
        areaController.text;
    streetController.text = user.streetName ?? streetController.text;
    houseNumberController.text = user.houseNo ?? houseNumberController.text;
    fullAddressController.text =
        user.customerAddress ?? fullAddressController.text;
  }

  Future<void> _openDeliveryAddressPicker() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ChooseAddressView()),
    );
    if (updated == true && mounted) {
      setState(() => _hydrateFrom(getIt<AccountCubit>().state));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeliveryContactFields(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            phoneController: phoneController,
            emailController: emailController,
          ),
          Gap(20.h),
          DeliveryAddressButton(onTap: _openDeliveryAddressPicker),
          Gap(16.h),
          DeliveryAddressFields(
            areaController: areaController,
            streetController: streetController,
            houseNumberController: houseNumberController,
            fullAddressController: fullAddressController,
          ),
          Gap(28.h),
          CustomElevatedButton.filled(
            title: 'Continue to Payment'.tr(),
            context: context,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final deliveryInfo = DeliveryInfoModel(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                  area: areaController.text,
                  street: streetController.text,
                  houseNumber: houseNumberController.text,
                  fullAddress: fullAddressController.text,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentView(
                      subtotal: widget.subtotal,
                      deliveryInfo: deliveryInfo,
                    ),
                  ),
                );
              }
            },
          ),
          Gap(12.h),
        ],
      ),
    );
  }
}
