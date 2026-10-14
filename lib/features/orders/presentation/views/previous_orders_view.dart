import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/orders/data/models/order_model.dart';
import 'package:the_one_test/features/orders/presentation/manager/orders_bloc/orders_bloc.dart';
import 'package:the_one_test/features/orders/presentation/widgets/order_card.dart';
import 'package:the_one_test/features/orders/presentation/widgets/orders_tab_toggle.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_page.dart';

class PreviousOrdersView extends StatefulWidget {
  const PreviousOrdersView({super.key});

  @override
  State<PreviousOrdersView> createState() => _PreviousOrdersViewState();
}

class _PreviousOrdersViewState extends State<PreviousOrdersView> {
  bool _showPrevious = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersBloc>()..add(const FetchOrders()),
      child: StorePage(
        key: ValueKey(context.locale.languageCode),
        title: 'My Orders'.tr(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              child: OrdersTabToggle(
                showPrevious: _showPrevious,
                onChanged: (value) => setState(() => _showPrevious = value),
              ),
            ),
            Expanded(
              child: BlocBuilder<OrdersBloc, BaseState<OrderModel>>(
                builder: (context, state) {
                  if (state.isLoading || state.isInitial) {
                    return const ListRowShimmer(itemCount: 3);
                  }
                  if (state.isFailure) {
                    return FailureWidget(
                      state: state,
                      errorMessage: state.errorMessage ?? '',
                      onRetry: () =>
                          context.read<OrdersBloc>().add(const FetchOrders()),
                    );
                  }
                  final orders = state.items
                      .where((o) => o.isPrevious == _showPrevious)
                      .toList();
                  return orders.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.receipt_long_outlined,
                          message: 'No orders yet'.tr(),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
                          itemCount: orders.length,
                          separatorBuilder: (_, _) => Gap(12.h),
                          itemBuilder: (context, index) =>
                              OrderCard(order: orders[index]),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
