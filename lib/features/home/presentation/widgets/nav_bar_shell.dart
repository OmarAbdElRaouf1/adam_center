import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'nav_bar_item.dart';
import 'nav_items_data.dart';

class NavBarShell extends StatelessWidget {
  const NavBarShell({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          constraints: BoxConstraints(
            minHeight: context.screenHeight * 0.06,
            maxHeight: context.screenHeight * 0.075,
          ),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.08),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double unselectedWidth = constraints.maxWidth / 8;
              final double selectedWidth = unselectedWidth * 2.4;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(navBarItems.length, (index) {
                  final bool isSelected = selectedIndex == index;
                  final item = navBarItems[index];

                  return NavBarItem(
                    index: index,
                    selectedIndex: selectedIndex,
                    icon: item.icon,
                    selectedIcon: item.selectedIcon,
                    title: item.title.tr(),
                    width: isSelected ? selectedWidth : unselectedWidth,
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
