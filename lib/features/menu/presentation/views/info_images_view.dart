import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/menu/data/models/info_image_model.dart';
import 'package:the_one_test/features/menu/presentation/manager/info_images_cubit/info_images_cubit.dart';

class InfoImagesView extends StatelessWidget {
  const InfoImagesView({super.key, required this.title, required this.fetcher});

  final String title;
  final InfoImagesFetcher fetcher;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Not resolved via getIt: `fetcher` is a per-call closure supplied by
      // the caller, not a getIt-managed dependency — there's nothing for DI
      // to wire together here.
      create: (_) => InfoImagesCubit(fetcher)..fetch(),
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: BlocBuilder<InfoImagesCubit, BaseState<InfoImageModel>>(
          builder: (context, state) {
            if (state.isLoading || state.isInitial) {
              return ListView(
                padding: EdgeInsets.all(16.w),
                children: List.generate(
                  3,
                  (_) => BlockShimmer(
                    height: 180.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                  ),
                ),
              );
            }
            if (state.isFailure) {
              return FailureWidget(
                state: state,
                errorMessage: state.errorMessage ?? 'Something went wrong'.tr(),
                onRetry: () => context.read<InfoImagesCubit>().fetch(),
              );
            }
            if (state.items.isEmpty) {
              return Center(child: Text('No data available'.tr()));
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => Gap(16.h),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card.r),
                child: Image.network(
                  state.items[index].imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 180.h,
                    color: Colors.grey.shade100,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
