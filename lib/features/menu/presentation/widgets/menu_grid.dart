import 'package:the_one_test/core/helper/helper.dart';

import 'menu_tiles.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = buildMenuTiles(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: tiles.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) => tiles[index],
    );
  }
}
