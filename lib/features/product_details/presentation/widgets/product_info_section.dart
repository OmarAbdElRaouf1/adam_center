import 'package:the_one_test/core/helper/helper.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
    );
  }
}
