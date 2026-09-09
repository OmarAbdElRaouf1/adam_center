import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/favorites/data/datasource/local_favorites_store.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';

/// A heart icon that toggles a product's favorite state through
/// [FavoriteBloc]. It only flips what it displays once the server confirms
/// the toggle — not optimistically on tap — so it tracks its own local
/// "confirmed" state, seeded from [LocalFavoritesStore] rather than
/// [initialIsFavorite]: the backend's own favorite flag doesn't reflect
/// adds/removes on this server, so the local store is the reliable source
/// of truth for what's actually favorited.
class FavoriteToggleButton extends StatefulWidget {
  const FavoriteToggleButton({
    super.key,
    required this.productId,
    required this.initialIsFavorite,
    this.size = 20,
  });

  final int productId;
  final bool initialIsFavorite;
  final double size;

  @override
  State<FavoriteToggleButton> createState() => _FavoriteToggleButtonState();
}

class _FavoriteToggleButtonState extends State<FavoriteToggleButton> {
  late bool _isFavorite = getIt<LocalFavoritesStore>().isFavorite(
    widget.productId,
  );
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, BaseState<ItemModel>>(
      bloc: getIt<FavoriteBloc>(),
      listenWhen: (_, state) =>
          state.metadata['action'] == 'toggle' &&
          state.metadata['productId'] == widget.productId,
      listener: (context, state) {
        if (state.isSuccess) {
          setState(() => _isFavorite = !_isFavorite);
          context.showSuccessMessage(
            _isFavorite
                ? 'Added to favorites'.tr()
                : 'Removed from favorites'.tr(),
          );
        } else if (state.isFailure) {
          context.showErrorMessage(state.errorMessage ?? '');
        }
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => getIt<FavoriteBloc>().add(
          ToggleFavorite(widget.productId, _isFavorite),
        ),
        child: AnimatedScale(
          scale: _pressed ? 0.8 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: AppShadows.card(context),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(_isFavorite),
                color: _isFavorite ? Colors.red : AppColors.primaryColor,
                size: widget.size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
