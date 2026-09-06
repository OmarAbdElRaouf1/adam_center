import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';

import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_event.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_checkout_bar.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_delivery_bar.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_empty.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_header.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:the_one_test/features/home/presentation/manager/nav_bar_cubit/nav_bar_cubit.dart';

const _cartTabIndex = 2;

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CartBloc>()..add(const FetchCartItems()),
      child: BlocListener<NavBarCubit, int>(
        listenWhen: (_, index) => index == _cartTabIndex,
        listener: (context, _) =>
            context.read<CartBloc>().add(const FetchCartItems()),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                children: [
                  const CartHeader(),
                  Gap(16.h),
                  CartDeliveryBar(),
                  Gap(16.h),
                  Expanded(
                    child: BlocBuilder<CartBloc, BaseState<CartItemModel>>(
                      builder: (context, state) {
                        if (state.isLoading || state.isInitial) {
                          return const SingleChildScrollView(
                            child: ListRowShimmer(itemCount: 3),
                          );
                        }
                        if (state.isFailure) {
                          return FailureWidget(
                            state: state,
                            errorMessage: state.errorMessage ?? '',
                            onRetry: () => context.read<CartBloc>().add(
                              const FetchCartItems(),
                            ),
                          );
                        }
                        if (state.items.isEmpty) {
                          return CartEmpty();
                        }
                        return ListView.separated(
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) => Gap(14.h),
                          itemBuilder: (context, index) =>
                              CartItemCard(item: state.items[index]),
                        );
                      },
                    ),
                  ),
                  Gap(10.h),
                  const CartCheckoutBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
