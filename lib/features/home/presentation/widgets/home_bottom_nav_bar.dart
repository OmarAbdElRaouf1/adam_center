import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/views/cart_view.dart';
import 'package:the_one_test/features/favorites/presentation/views/favorites_view.dart';
import 'package:the_one_test/features/home/presentation/views/categories_view.dart';
import 'package:the_one_test/features/home/presentation/views/search_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';

enum HomeTab { home, favorites, categories, search }

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key, this.current});

  /// Highlighted tab; null on pages that aren't a tab of their own.
  final HomeTab? current;

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _open(BuildContext context, HomeTab tab, Widget page) {
    if (tab != current) _push(context, page);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom * 0.5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
        boxShadow: AppShadows.card(context),
      ),
      child: SizedBox(
        height: 76.h,
        child: Row(
          children: [
            _NavIcon(
              icon: current == HomeTab.home
                  ? Icons.home_rounded
                  : Icons.home_outlined,
              isActive: current == HomeTab.home,
              onTap: () => popToStoreRoot(context),
            ),
            _NavIcon(
              icon: Icons.favorite_border_rounded,
              color: _tint,
              isActive: current == HomeTab.favorites,
              onTap: () =>
                  _open(context, HomeTab.favorites, const FavoritesView()),
            ),
            Expanded(
              child: _CartButton(onTap: () => _push(context, const CartView())),
            ),
            _NavIcon(
              icon: Icons.grid_view_outlined,
              isActive: current == HomeTab.categories,
              onTap: () =>
                  _open(context, HomeTab.categories, const CategoriesView()),
            ),
            _NavIcon(
              icon: Icons.search_rounded,
              isActive: current == HomeTab.search,
              onTap: () => _open(context, HomeTab.search, const SearchView()),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft brand tint used for the active icon, the heart and the cart circle.
final Color _tint = AppColors.primaryColor.withValues(alpha: 0.55);

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    this.onTap,
    this.isActive = false,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 28.r,
        child: Icon(
          icon,
          size: 30.sp,
          color: isActive ? _tint : color ?? Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 62.w,
              height: 62.w,
              decoration: BoxDecoration(color: _tint, shape: BoxShape.circle),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            PositionedDirectional(
              top: 2.h,
              end: 0,
              child: BlocBuilder<CartBloc, BaseState<CartItemModel>>(
                bloc: getIt<CartBloc>(),
                builder: (context, state) {
                  final count = state.items.fold<int>(
                    0,
                    (sum, item) => sum + item.salesQuantity,
                  );

                  if (count == 0) return const SizedBox.shrink();

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    constraints: BoxConstraints(
                      minWidth: 20.w,
                      minHeight: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        context.localizeDigits(count.toString()),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          height: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
