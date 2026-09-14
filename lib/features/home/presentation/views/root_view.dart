import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:the_one_test/core/services/service_locator/service_locator.dart';
import 'package:the_one_test/core/widgets/custom_snack_bar.dart';

import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/views/cart_view.dart';

import 'package:the_one_test/features/category_products/presentation/manager/category_bloc/category_bloc.dart';

import 'package:the_one_test/features/favorites/presentation/views/favorites_view.dart';

import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:the_one_test/features/home/presentation/views/categories_view.dart';
import 'package:the_one_test/features/home/presentation/views/home_view.dart';

import '../widgets/app_drawer.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  final NavBarCubit _navBarCubit = NavBarCubit();

  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();

    // Fetch cart once when RootView is initialized.
    getIt<CartBloc>().add(const FetchCartItems());
  }

  @override
  void dispose() {
    _navBarCubit.close();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    final currentIndex = _navBarCubit.state;

    if (currentIndex != 0) {
      _navBarCubit.changeIndex(0);
      return;
    }

    final now = DateTime.now();

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 3)) {
      _lastBackPressTime = now;

      showCustomSnackBar(context, 'Press back again to exit'.tr());

      return;
    }

    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeView(),
      const CategoriesView(),
      const CartView(),
      const FavoritesView(),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _navBarCubit),

        BlocProvider(
          create: (_) =>
              getIt<CategoryBloc>()..add(const GetMainCategoriesEvent()),
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          _handleBack(context);
        },
        child: Scaffold(
          extendBody: true,

          drawer: const AppDrawer(),

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
