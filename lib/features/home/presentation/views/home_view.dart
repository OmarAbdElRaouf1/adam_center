import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';

import 'package:the_one_test/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:the_one_test/features/cart/presentation/manager/add_to_cart_bloc/add_to_cart_bloc.dart';
import 'package:the_one_test/features/category_products/presentation/manager/product_bloc/product_bloc.dart';
import 'package:the_one_test/features/favorites/presentation/manager/favorite_bloc/favorite_bloc.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';

import 'package:the_one_test/features/home/presentation/widgets/custom_row.dart';
import 'package:the_one_test/features/home/presentation/widgets/fetched_banner_section.dart';
import 'package:the_one_test/features/home/presentation/widgets/fetched_product_section.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_top_bar.dart';
import 'package:the_one_test/features/home/presentation/widgets/parent_category_preview_list.dart';
import 'package:the_one_test/features/home/presentation/widgets/text_banner.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddToCartBloc>(create: (_) => getIt<AddToCartBloc>()),
        BlocProvider<FavoriteBloc>(create: (_) => getIt<FavoriteBloc>()),
      ],
      child: BlocListener<AddToCartBloc, BaseState<void>>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.showSuccessMessage('Added to Cart'.tr());
          } else if (state.isFailure) {
            context.showErrorMessage(state.errorMessage ?? '');
          }
        },
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              top: 5.h,
              bottom: context.screenHeight * 0.12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeTopBar(),

                Gap(10.h),

                const CustomSearchField(),

                Gap(20.h),

                FetchedBannerSlider(endpoint: EndPoints.bannerOne),

                Gap(20.h),

                const TextBanner(),

                Gap(20.h),

                CustomRow(
                  title: 'Categories'.tr(),
                  seeAll: 'See All'.tr(),
                  onSeeAllPressed: () {
                    context.read<NavBarCubit>().changeIndex(1);
                  },
                ),

                Gap(20.h),

                const ParentCategoryPreviewList(),

                Gap(20.h),

                FetchedProductSection(
                  title: 'New Products'.tr(),
                  event: const GetNewProductsEvent(),
                ),

                Gap(20.h),

                FetchedBannerSlider(endpoint: EndPoints.bannerTwo),

                Gap(20.h),

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

                Gap(20.h),

                FetchedBannerSlider(endpoint: EndPoints.bannerThree),

                Gap(40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
