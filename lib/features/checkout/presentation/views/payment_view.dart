import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/widgets/custom_button.dart';
import 'package:the_one_test/features/checkout/data/models/delivery_info_model.dart';
import 'package:the_one_test/features/checkout/presentation/manager/payment_bloc/payment_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/discount_code_field.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/payment_methods_section.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/payment_summary.dart';
import 'package:the_one_test/features/home/presentation/views/root_view.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({
    super.key,
    required this.subtotal,
    required this.deliveryInfo,
  });

  final double subtotal;
  final DeliveryInfoModel deliveryInfo;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final discountController = TextEditingController();

  @override
  void dispose() {
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentBloc>(
        param1: widget.subtotal,
        param2: widget.deliveryInfo,
      ),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listenWhen: (previous, current) =>
            current.discountAttempt != previous.discountAttempt ||
            current.orderPlaced != previous.orderPlaced ||
            current.orderError != previous.orderError,
        listener: (context, state) {
          if (state.orderPlaced) {
            context.showSuccessMessage('Order placed'.tr());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RootView()),
            );
            return;
          }
          if (state.orderError != null) {
            context.showErrorMessage(state.orderError!);
            return;
          }
          if (state.discountCodeValid) {
            context.showSuccessMessage('Discount applied'.tr());
          } else {
            context.showErrorMessage('Please enter discount code'.tr());
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: ValueKey(context.locale.languageCode),
            appBar: const CustomAppBar(titleText: 'Pay'),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Do you have a discount code?'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(10.h),
                  DiscountCodeField(
                    controller: discountController,
                    onActivate: () => context.read<PaymentBloc>().add(
                      ApplyDiscountCode(discountController.text),
                    ),
                  ),
                  Gap(28.h),
                  PaymentMethodsSection(
                    selected: state.selectedMethod,
                    onSelect: (method) => context.read<PaymentBloc>().add(
                      SelectPaymentMethod(method),
                    ),
                  ),
                  Gap(20.h),
                  PaymentSummary(
                    subtotal: state.subtotal,
                    deliveryFee: state.deliveryFee,
                    discountRate: state.discountRate,
                    discountValue: state.discountValue,
                    total: state.total,
                  ),
                  Gap(28.h),
                  CustomElevatedButton.filled(
                    backgroundColor: AppColors.primaryColor,
                    title: state.isPlacingOrder ? '...'.tr() : 'Pay'.tr(),
                    context: context,
                    onPressed: state.isPlacingOrder
                        ? () {}
                        : () => context.read<PaymentBloc>().add(
                            const PlaceOrder(),
                          ),
                  ),
                  Gap(12.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
