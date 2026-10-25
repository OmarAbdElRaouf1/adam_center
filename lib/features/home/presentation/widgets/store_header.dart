import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_logo.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/views/cart_view.dart';

/// Top bar shared by the store's inner pages: back + menu on the start
/// side, the store name in the middle and a page-specific [action] on the
/// end side. [bottom] (e.g. a search field) sits under the row inside the
/// same white surface.
class StoreHeader extends StatelessWidget {
  const StoreHeader({
    super.key,
    this.action,
    this.bottom,
    this.showMenu = true,
  });

  final Widget? action;
  final Widget? bottom;

  /// False on pages without the drawer (e.g. Favorites).
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 52.h,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                StoreLogo(size: 50.h),
                PositionedDirectional(
                  start: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canPop)
                        _HeaderIcon(
                          icon: Icons.arrow_back_ios_new_rounded,
                          size: 22.sp,
                          onTap: () => Navigator.maybePop(context),
                        ),
                      if (canPop && showMenu) Gap(14.w),
                      if (showMenu)
                        _HeaderIcon(
                          icon: Icons.menu_rounded,
                          size: 32.sp,
                          onTap: () => Scaffold.of(context).openDrawer(),
                        ),
                    ],
                  ),
                ),
                if (action != null)
                  PositionedDirectional(end: 0, child: action!),
              ],
            ),
          ),
          if (bottom != null) ...[Gap(10.h), bottom!],
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.onTap, this.size});

  final IconData icon;
  final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24.r,
      child: Icon(icon, color: AppColors.primaryColor, size: size ?? 28.sp),
    );
  }
}

/// Header [StoreHeader.action] that opens a page-specific sheet (sorting).
class StoreHeaderFilterAction extends StatelessWidget {
  const StoreHeaderFilterAction({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _HeaderIcon(icon: Icons.filter_alt_outlined, onTap: onTap);
  }
}

/// Header [StoreHeader.action] showing the cart with its item count.
class StoreHeaderCartAction extends StatelessWidget {
  const StoreHeaderCartAction({super.key});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 24.r,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartView()),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primaryColor,
            size: 28.sp,
          ),
          PositionedDirectional(
            bottom: -4.h,
            end: -6.w,
            child: BlocBuilder<CartBloc, BaseState<CartItemModel>>(
              bloc: getIt<CartBloc>(),
              builder: (context, state) {
                final count = state.items.fold<int>(
                  0,
                  (sum, item) => sum + item.salesQuantity,
                );
                if (count == 0) return const SizedBox.shrink();

                return Container(
                  constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      context.localizeDigits(count.toString()),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
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
    );
  }
}
