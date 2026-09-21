import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/category_products/presentation/widgets/category_products_grid.dart';

class MoreProductsGridView extends StatelessWidget {
  const MoreProductsGridView({super.key, required this.title, this.products});

  final String title;
  final List<Map<String, String>>? products;

  @override
  Widget build(BuildContext context) {
    final products = this.products ?? const <Map<String, String>>[];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Gap(16.w),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                ),

                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),

                // مساحة فاضية بنفس عرض الزرار عشان العنوان يبقى في النص بالظبط
                Gap(48.w),
              ],
            ),

            Gap(20.h),

            Expanded(
              child: CategoryProductsGrid(
                products: products,
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 8.h,
                  bottom: 110.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
