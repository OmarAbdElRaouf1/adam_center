import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/checkout/presentation/widgets/delivery_info_form.dart';

class DeliveryInfoView extends StatelessWidget {
  const DeliveryInfoView({super.key, required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(context.locale.languageCode),
      appBar: const CustomAppBar(titleText: 'Delivery Info'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: DeliveryInfoForm(subtotal: subtotal),
      ),
    );
  }
}
