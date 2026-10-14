import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';

import 'package:the_one_test/features/cart/data/models/cart_model.dart';
import 'package:the_one_test/features/cart/presentation/manager/cart_bloc/cart_bloc.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_checkout_bar.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_delivery_bar.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_empty.dart';
import 'package:the_one_test/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:the_one_test/features/home/presentation/widgets/home_chat_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_breadcrumb.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_header.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_scaffold.dart';
import 'package:the_one_test/features/home/presentation/widgets/text_banner.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_pull_to_refresh.dart';

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

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text('Are you sure you want to empty the cart?'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Empty Cart'.tr(),
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) getIt<CartBloc>().add(const ClearCart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, BaseState<CartItemModel>>(
      bloc: getIt<CartBloc>(),
      builder: (context, state) {
        final items = state.items;

        return Scaffold(
          floatingActionButton: const HomeChatButton(),
          bottomNavigationBar: items.isEmpty ? null : const CartCheckoutBar(),
          body: Column(
            children: [
              const StoreHeader(showMenu: false),
              Expanded(
                child: StorePullToRefresh(
                  onRefresh: () {
                    final bloc = getIt<CartBloc>()..add(const FetchCartItems());
                    return untilLoaded(bloc);
                  },
                  builder: (controller) => ListView(
                    controller: controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 24.h, bottom: 40.h),
                    children: [
                      StoreBreadcrumb(current: 'Cart'.tr()),
                      Gap(24.h),
                      const TextBanner(),
                      if (state.isFailure)
                        FailureWidget(
                          state: state,
                          errorMessage: state.errorMessage ?? '',
                          onRetry: () =>
                              getIt<CartBloc>().add(const FetchCartItems()),
                        )
                      else if (items.isEmpty)
                        const CartEmpty()
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Gap(40.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      context.localizeDigits(
                                        '${'Cart Contents'.tr()} (${items.length}):',
                                      ),
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _confirmClear,
                                    child: Text(
                                      'Empty Cart'.tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.red,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(14.h),
                              for (final item in items) ...[
                                CartItemCard(
                                  key: ValueKey(item.productID),
                                  item: item,
                                ),
                                Gap(14.h),
                              ],
                              Gap(18.h),
                              const CartDeliveryBar(),
                              Gap(32.h),
                              SizedBox(
                                height: 52.h,
                                child: OutlinedButton(
                                  onPressed: () => popToStoreRoot(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    side: BorderSide(
                                      color: Colors.grey.shade500,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.chip.r,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Continue Shopping'.tr(),
                                    style: TextStyle(fontSize: 17.sp),
                                  ),
                                ),
                              ),
                              Gap(80.h),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
