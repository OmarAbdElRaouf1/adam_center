import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/checkout/data/models/address_model.dart';
import 'package:the_one_test/features/checkout/presentation/manager/choose_address_bloc/choose_address_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/views/add_address_view.dart';

class ChooseAddressView extends StatelessWidget {
  const ChooseAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChooseAddressBloc>()..add(const LoadAddresses()),
      child: const _ChooseAddressBody(),
    );
  }
}

class _ChooseAddressBody extends StatelessWidget {
  const _ChooseAddressBody();

  void _selectAddress(BuildContext context, AddressModel address) {
    context.read<ChooseAddressBloc>().add(SelectAddress(address));
  }

  Future<void> _addNewAddress(BuildContext context) async {
    final bloc = context.read<ChooseAddressBloc>();
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressView()),
    );
    if (added == true) {
      bloc.add(const LoadAddresses());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChooseAddressBloc, BaseState<AddressModel>>(
      listenWhen: (previous, current) =>
          current.status == Status.success &&
          current.metadata['action'] == 'select',
      listener: (context, state) => Navigator.pop(context, true),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Choose Address'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Gap(4.h),
                        InkWell(
                          onTap: () => _addNewAddress(context),
                          child: Text(
                            'Add Address'.tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(12.h),
                Divider(color: Theme.of(context).dividerTheme.color),
                Gap(12.h),
                Text(
                  'Saved Addresses'.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(16.h),
                Expanded(
                  child:
                      BlocBuilder<ChooseAddressBloc, BaseState<AddressModel>>(
                        builder: (context, state) {
                          if (state.isLoading || state.isInitial) {
                            return const ListRowShimmer(itemCount: 3);
                          }
                          if (state.isFailure) {
                            return FailureWidget(
                              state: state,
                              errorMessage: state.errorMessage ?? '',
                              onRetry: () => context
                                  .read<ChooseAddressBloc>()
                                  .add(const LoadAddresses()),
                            );
                          }
                          if (state.items.isEmpty) {
                            return EmptyStateWidget(
                              icon: Icons.location_off_outlined,
                              message: 'No saved addresses yet'.tr(),
                            );
                          }
                          return ListView.separated(
                            itemCount: state.items.length,
                            separatorBuilder: (_, _) => Gap(14.h),
                            itemBuilder: (context, index) {
                              final address = state.items[index];
                              return _AddressCard(
                                address: address,
                                onTap: () => _selectAddress(context, address),
                              );
                            },
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.onTap});

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryColor),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.districtLabel ?? 'Address'.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  if (address.isMain) ...[
                    Gap(2.h),
                    Text(
                      '(${'Main Address'.tr()})',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                  Gap(6.h),
                  Text(
                    address.arabicName ?? address.englishName ?? '',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    address.customerPhone ?? '',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  Gap(4.h),
                  Text(
                    address.customerAddress ?? '',
                    style: TextStyle(fontSize: 12.5.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
