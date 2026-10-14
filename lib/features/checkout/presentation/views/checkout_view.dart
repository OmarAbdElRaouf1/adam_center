import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart' hide CustomTextFormField;
import 'package:the_one_test/core/widgets/widgets/validators.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/auth/presentation/widgets/location_dropdowns.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/checkout/data/models/delivery_info_model.dart';
import 'package:the_one_test/features/checkout/presentation/manager/payment_bloc/payment_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/views/choose_address_view.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/payment_summary.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_page.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_network_image.dart';

/// Single-page checkout: contact details, delivery address, order summary,
/// discount code and totals. Payment is always cash on delivery.
class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key, required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The address is only known on submit — it travels with PlaceOrder.
      create: (_) =>
          getIt<PaymentBloc>(param1: subtotal, param2: DeliveryInfoModel.empty),
      child: const _CheckoutBody(),
    );
  }
}

class _CheckoutBody extends StatefulWidget {
  const _CheckoutBody();

  @override
  State<_CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<_CheckoutBody> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _block = TextEditingController();
  final _street = TextEditingController();
  final _gada = TextEditingController();
  final _house = TextEditingController();
  final _floor = TextEditingController();
  final _notes = TextEditingController();
  final _apartment = TextEditingController();

  GovernorateModel? _governorate;
  DistrictModel? _district;
  String? _initialGovernorate;
  String? _initialDistrict;

  // Bumped when a saved address is picked so the dropdowns re-initialize.
  int _addressVersion = 0;

  @override
  void initState() {
    super.initState();
    _hydrateFrom(getIt<AccountCubit>().state, includeContact: true);
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _phone,
      _email,
      _block,
      _street,
      _gada,
      _house,
      _floor,
      _notes,
      _apartment,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _hydrateFrom(UserModel? user, {bool includeContact = false}) {
    if (user == null) return;
    if (includeContact) {
      _name.text = [
        user.englishName ?? user.arabicName,
        user.lastName,
      ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
      _phone.text = user.customerPhone;
      _email.text = user.email ?? '';
    }
    _block.text = user.block ?? '';
    _street.text = user.streetName ?? '';
    _gada.text = user.gada ?? '';
    _house.text = user.houseNo ?? '';
    _floor.text = user.floor ?? '';
    _apartment.text = user.apartment ?? '';
    _notes.text = user.addressNotes ?? '';
    _initialGovernorate = user.regionName;
    _initialDistrict = user.districtName;
    _governorate = null;
    _district = null;
  }

  Future<void> _pickSavedAddress() async {
    final picked = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ChooseAddressView()),
    );
    if (picked == true && mounted) {
      setState(() {
        _hydrateFrom(getIt<AccountCubit>().state);
        _addressVersion++;
      });
    }
  }

  void _submit() {
    final validForm = _formKey.currentState!.validate();
    if (_governorate == null) {
      context.showErrorMessage('Please select governorate'.tr());
      return;
    }
    if (!validForm) return;

    context.read<PaymentBloc>().add(
      PlaceOrder(
        DeliveryInfoModel(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          governorate: _governorate!.name,
          area: _district?.name ?? '',
          block: _block.text.trim(),
          street: _street.text.trim(),
          gada: _gada.text.trim(),
          house: _house.text.trim(),
          floor: _floor.text.trim(),
          apartment: _apartment.text.trim(),
          notes: _notes.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listenWhen: (previous, current) =>
          current.orderPlaced != previous.orderPlaced ||
          current.orderError != previous.orderError,
      listener: (context, state) {
        if (state.orderPlaced) {
          context.showSuccessMessage('Order placed'.tr());
          getIt<CartBloc>().add(const FetchCartItems());
          popToStoreRoot(context);
          return;
        }
        if (state.orderError != null) {
          context.showErrorMessage(state.orderError!);
        }
      },
      builder: (context, state) {
        return StorePage(
          key: ValueKey(context.locale.languageCode),
          title: 'Complete Order'.tr(),
          bottomBar: _BottomBar(
            child: StoreButton(
              label: 'Finish Order'.tr(),
              isLoading: state.isPlacingOrder,
              onPressed: _submit,
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 60.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _contactSection(),
                  Gap(40.h),
                  _addressSection(),
                  Gap(40.h),
                  _summarySection(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _contactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _SectionTitle('Contact Information'.tr())),
            GestureDetector(
              onTap: _pickSavedAddress,
              child: Text(
                'My Addresses'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        Gap(18.h),
        _CheckoutField(
          hint: 'Name'.tr(),
          required: true,
          controller: _name,
          validator: Validators.validateEmpty,
        ),
        Gap(14.h),
        _CheckoutField(
          hint: 'Mobile Number'.tr(),
          required: true,
          controller: _phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          validator: Validators.phoneNumberValidator,
          trailing: const _CountryCode(),
        ),
        Gap(14.h),
        _CheckoutField(
          hint: 'Email'.tr(),
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value ?? '').trim().isEmpty
              ? null
              : Validators.emailValidator(value),
        ),
      ],
    );
  }

  Widget _addressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('Address'.tr()),
        Gap(18.h),
        _FieldLabel('Country'.tr(), required: true),
        Gap(10.h),
        _CheckoutField(hint: 'Egypt'.tr(), value: 'Egypt'.tr(), readOnly: true),
        Gap(22.h),
        LocationDropdowns(
          key: ValueKey(_addressVersion),
          initialGovernorateName: _initialGovernorate,
          initialDistrictName: _initialDistrict,
          governorateLabel: _FieldLabel('Governorate'.tr(), required: true),
          districtLabel: _FieldLabel('Area'.tr()),
          onSelectionChanged: (governorate, district) {
            _governorate = governorate;
            _district = district;
          },
        ),
        Gap(22.h),
        _CheckoutField(
          hint: 'Block'.tr(),
          required: true,
          controller: _block,
          validator: Validators.validateEmpty,
        ),
        Gap(14.h),
        _CheckoutField(
          hint: 'Street'.tr(),
          required: true,
          controller: _street,
          validator: Validators.validateEmpty,
        ),
        Gap(14.h),
        _CheckoutField(hint: 'Gada'.tr(), controller: _gada),
        Gap(14.h),
        _CheckoutField(
          hint: 'House'.tr(),
          required: true,
          controller: _house,
          validator: Validators.validateEmpty,
        ),
        Gap(14.h),
        _CheckoutField(hint: 'Floor'.tr(), controller: _floor),
        Gap(14.h),
        _CheckoutField(hint: 'Delivery Notes'.tr(), controller: _notes),
        Gap(14.h),
        _CheckoutField(hint: 'Apartment'.tr(), controller: _apartment),
      ],
    );
  }

  Widget _summarySection(PaymentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle('Order Summary'.tr()),
        Gap(18.h),
        BlocBuilder<CartBloc, BaseState<CartItemModel>>(
          bloc: getIt<CartBloc>(),
          builder: (context, cart) => Column(
            children: [
              for (final item in cart.items) ...[
                _SummaryItem(item: item),
                Gap(14.h),
              ],
            ],
          ),
        ),
        Gap(10.h),
        PaymentSummary(
          subtotal: state.subtotal,
          deliveryFee: state.deliveryFee,
          total: state.total,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500),
    );
  }
}

/// Field caption with a red required mark.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: TextStyle(fontSize: 16.sp),
        children: [
          if (required)
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.red),
            ),
        ],
      ),
    );
  }
}

/// White outlined field whose placeholder carries the required mark.
class _CheckoutField extends StatelessWidget {
  const _CheckoutField({
    required this.hint,
    this.controller,
    this.value,
    this.required = false,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.trailing,
  });

  final String hint;
  final TextEditingController? controller;

  /// Fixed text for read-only fields.
  final String? value;
  final bool required;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.chip.r),
      borderSide: BorderSide(color: color),
    );

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? value : null,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        hint: Text.rich(
          TextSpan(
            text: hint,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade500),
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.red),
                ),
            ],
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        suffixIcon: trailing,
        border: border(Colors.grey.shade300),
        enabledBorder: border(Colors.grey.shade300),
        focusedBorder: border(AppColors.primaryColor),
        errorBorder: border(AppColors.red),
        focusedErrorBorder: border(AppColors.red),
      ),
    );
  }
}

/// "🇪🇬 EG +20" box at the end of the phone field.
class _CountryCode extends StatelessWidget {
  const _CountryCode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96.w,
      margin: EdgeInsets.all(1.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: BorderDirectional(
          start: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(
        '🇪🇬  EG +20',
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.primaryColor.withValues(alpha: 0.06),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70.w,
          height: 70.w,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.chip.r),
            child: StoreNetworkImage(
              url: item.productImage,
              placeholder: placeholder,
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Text(
            context.localizeDigits(
              '${item.productName} (x${item.salesQuantity})',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15.sp),
          ),
        ),
        Gap(12.w),
        Text(
          context.localizeDigits(
            '${item.total.toStringAsFixed(0)} ${'EGP'.tr()}',
          ),
          style: TextStyle(fontSize: 15.sp),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: AppShadows.raised(context),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
