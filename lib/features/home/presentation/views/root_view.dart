import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_one_test/core/services/service_locator/service_locator.dart';
import 'package:the_one_test/features/cart/presentation/views/cart_view.dart';
import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';
import 'package:the_one_test/features/favorites/presentation/views/favorites_view.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:the_one_test/features/home/presentation/views/categories_view.dart';
import 'package:the_one_test/features/home/presentation/views/home_view.dart';
import 'package:the_one_test/features/menu/presentation/views/menu_view.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeView(),
      const CategoriesView(),
      const CartView(),
      const FavoritesView(),
      const MenuView(),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavBarCubit()),
        BlocProvider(
          create: (_) =>
              getIt<CategoryBloc>()..add(const GetMainCategoriesEvent()),
        ),
      ],
      child: PopScope(
        canPop: false,
        child: Scaffold(
          extendBody: true,
          body: BlocBuilder<NavBarCubit, int>(
            builder: (context, selectedIndex) {
              return IndexedStack(
                key: ValueKey(context.locale.languageCode),
                index: selectedIndex,
                children: pages,
              );
            },
          ),
          bottomNavigationBar: CustomBottomNavBar(
            key: ValueKey(context.locale.languageCode),
          ),
        ),
      ),
    );
  }
}
