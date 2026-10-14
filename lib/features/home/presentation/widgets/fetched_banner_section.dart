import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/home/data/models/banner_model.dart';
import 'package:the_one_test/features/home/presentation/manager/banner_bloc/banner_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/banner_slider.dart';

class FetchedBannerSlider extends StatelessWidget {
  const FetchedBannerSlider({super.key, required this.endpoint});

  final String endpoint;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BannerBloc>(param1: endpoint)..add(const GetBannerEvent()),
      child: BlocBuilder<BannerBloc, BaseState<BannerModel>>(
        builder: (context, state) {
          if (state.isLoading) {
            return BlockShimmer(
              height: BannerSlider.heightOf(context),
              borderRadius: BorderRadius.zero,
            );
          }
          if (state.items.isEmpty) {
            return const SizedBox.shrink();
          }
          return BannerSlider(
            banners: state.items
                .map((banner) => {'image': banner.imagePath})
                .toList(),
          );
        },
      ),
    );
  }
}
