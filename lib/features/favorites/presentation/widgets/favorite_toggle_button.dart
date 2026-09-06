import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/models/item_model.dart';
import 'package:the_one_test/features/favorites/data/datasource/local_favorites_store.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_event.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, BaseState<ItemModel>>(
      listenWhen: (_, state) =>
          state.metadata['action'] == 'toggle' &&
          state.metadata['productId'] == widget.productId,
      listener: (context, state) {
        if (state.isSuccess) {
          setState(() => _isFavorite = !_isFavorite);
        } else if (state.isFailure) {
          context.showErrorMessage(state.errorMessage ?? '');
        }
      },
      child: GestureDetector(
        onTap: () => context.read<FavoriteBloc>().add(
          ToggleFavorite(widget.productId, _isFavorite),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: AppShadows.card(context),
          ),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : AppColors.primaryColor,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
