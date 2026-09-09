import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';

import 'cart_quantity_stepper.dart';

/// A small "+" button that turns into a quantity stepper once the product
/// is in the cart — reflects the shared [CartBloc] state, so it stays in
/// sync everywhere the product is shown (Home, Category, Favorites,
/// Product Details) without any screen having to track quantity itself.
///
/// The whole control reserves a fixed-width footprint (wide enough for the
/// stepper) and always aligns its content to the start edge within it, so
/// switching between the "+" circle and the wider stepper never changes the
/// control's own bounding box — the parent's Positioned/PositionedDirectional
/// anchor point this is placed at never moves, no matter which state shows.
class AddToCartControl extends StatelessWidget {
  const AddToCartControl({
    super.key,
    required this.productId,
    required this.barCode,
    this.size = 32,
  });

  final int productId;
  final String barCode;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, BaseState<CartItemModel>>(
      bloc: getIt<CartBloc>(),
      builder: (context, state) {
        final index = state.items.indexWhere(
          (item) => item.productID == productId,
        );
        final quantity = index >= 0 ? state.items[index].salesQuantity : 0;

        return SizedBox(
          // Fixed on both axes — the stepper (with its padding/border) is
          // taller than the bare "+" circle, so leaving height intrinsic
          // still let the box grow/shrink between states and drift against
          // a bottom-anchored Positioned. Both dimensions now stay constant
          // no matter which state is showing, so the parent's anchor point
          // never moves.
          width: size * 3.6,
          height: size + 14,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              // AnimatedSwitcher's default layout centers the outgoing and
              // incoming children against each other's combined size while
              // both are on screen mid-transition — since the stepper is
              // bigger than the "+" circle, that briefly nudges the smaller
              // one away from its resting spot before it snaps back once
              // the transition finishes. Keeping both pinned to the same
              // start edge during the transition itself removes that jump.
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [...previousChildren, ?currentChild],
              ),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: quantity == 0
                  ? _AddButton(
                      key: const ValueKey('add'),
                      size: size,
                      onTap: () => getIt<CartBloc>().add(
                        IncrementItem(productId, barCode),
                      ),
                    )
                  : Container(
                      key: const ValueKey('stepper'),
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppRadius.pill.r),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: AppShadows.card(context),
                      ),
                      child: CartQuantityStepper(
                        quantity: quantity,
                        onIncrement: () => getIt<CartBloc>().add(
                          IncrementItem(productId, barCode),
                        ),
                        onDecrement: () => getIt<CartBloc>().add(
                          DeleteCartItem(productId, barCode),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _AddButton extends StatefulWidget {
  const _AddButton({super.key, required this.size, required this.onTap});

  final double size;
  final VoidCallback onTap;

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: AppShadows.card(context),
          ),
          child: Icon(Icons.add, color: Colors.white, size: widget.size * 0.55),
        ),
      ),
    );
  }
}
