import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_list_view_item.dart';
import 'package:the_one_test/features/product_details/presentation/views/product_details_view.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key, required this.products});

  final List<Map<String, String>> products;

  @override
  Widget build(BuildContext context) {
    final visible = products.length > 10 ? products.sublist(0, 10) : products;
    // Height comes from the tallest card instead of a screen-height fraction:
    // a card's content (category line, discount badge, description, larger
    // system font) varies, so any fixed height eventually overflows.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const BouncingScrollPhysics(),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) Gap(14.w),
              SizedBox(
                key: ValueKey(visible[i]['id']),
                width: (context.screenWidth * 0.4).clamp(140.0, 220.0),
                child: HomeListViewItem(
                  product: visible[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsView(product: visible[i]),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
