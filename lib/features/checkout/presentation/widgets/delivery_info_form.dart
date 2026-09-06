import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/under_construction_screen.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/checkout/data/models/delivery_info_model.dart';
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
  final streetController = TextEditingController();
  final houseNumberController = TextEditingController();
  final fullAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedArea;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    streetController.dispose();
    houseNumberController.dispose();
    fullAddressController.dispose();
    super.dispose();
  }

  void _openDeliveryAddressPicker() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UnderConstructionScreen(title: 'Delivery Address'.tr()),
      ),
    );
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
            selectedArea: selectedArea,
            onAreaChanged: (value) => setState(() => selectedArea = value),
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
                  area: selectedArea,
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
