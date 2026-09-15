import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';

import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_checkout_bar.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_delivery_bar.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_empty.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_item_card.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    getIt<CartBloc>().add(const FetchCartItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titleText: 'Cart'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              CartDeliveryBar(),
              Gap(16.h),
              Expanded(
                child: BlocBuilder<CartBloc, BaseState<CartItemModel>>(
                  bloc: getIt<CartBloc>(),
                  builder: (context, state) {
                    if (state.isFailure) {
                      return FailureWidget(
                        state: state,
                        errorMessage: state.errorMessage ?? '',
                        onRetry: () =>
                            getIt<CartBloc>().add(const FetchCartItems()),
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
    );
  }
}
