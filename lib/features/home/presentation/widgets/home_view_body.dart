import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/home/presentation/widgets/fetched_banner_section.dart';
import 'package:the_one_test/features/home/presentation/widgets/fetched_product_section.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_section_title.dart';
import 'package:the_one_test/features/home/presentation/widgets/parent_category_preview_list.dart';
import 'package:the_one_test/features/home/presentation/widgets/text_banner.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextBanner(),

        Gap(28.h),

        FetchedBannerSlider(endpoint: EndPoints.bannerOne),

        Gap(32.h),

        HomeSectionTitle(title: 'Shop by Category'.tr()),

        Gap(32.h),

        const ParentCategoryPreviewList(),

        Gap(28.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: FetchedProductSection(
            title: 'New Products'.tr(),
            event: const GetNewProductsEvent(),
          ),
        ),

        Gap(20.h),

        FetchedBannerSlider(endpoint: EndPoints.bannerTwo),

        Gap(20.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              FetchedProductSection(
                title: 'Best Sellers'.tr(),
                event: const GetBestSellersEvent(),
                gap: 10,
              ),

              Gap(20.h),

              FetchedProductSection(
                title: 'Discounted Products'.tr(),
                event: const GetBiggestDiscountProductsEvent(),
                gap: 10,
              ),
            ],
          ),
        ),

        Gap(20.h),

        FetchedBannerSlider(endpoint: EndPoints.bannerThree),
      ],
    );
  }
}
