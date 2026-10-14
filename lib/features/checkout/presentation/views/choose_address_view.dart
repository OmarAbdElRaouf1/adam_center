import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/checkout/data/models/address_model.dart';
import 'package:the_one_test/features/checkout/presentation/manager/choose_address_bloc/choose_address_bloc.dart';
import 'package:the_one_test/features/checkout/presentation/views/add_address_view.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_button.dart';
import 'package:the_one_test/features/home/presentation/widgets/store_page.dart';

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
      child: StorePage(
        title: 'Choose Address'.tr(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoreSectionLabel('Saved Addresses'.tr()),
              Gap(14.h),
              Expanded(
                child: BlocBuilder<ChooseAddressBloc, BaseState<AddressModel>>(
                  builder: (context, state) {
                    if (state.isLoading || state.isInitial) {
                      return const ListRowShimmer(itemCount: 3);
                    }
                    if (state.isFailure) {
                      return FailureWidget(
                        state: state,
                        errorMessage: state.errorMessage ?? '',
                        onRetry: () => context.read<ChooseAddressBloc>().add(
                          const LoadAddresses(),
                        ),
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
                      separatorBuilder: (_, _) => Gap(12.h),
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
              Gap(16.h),
              StoreButton(
                label: 'Add Address'.tr(),
                icon: Icons.add_location_alt_outlined,
                outlined: true,
                onPressed: () => _addNewAddress(context),
              ),
              Gap(60.h),
            ],
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
    final details = TextStyle(fontSize: 14.sp, color: Colors.grey.shade700);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.badge.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.badge.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            address.districtLabel ?? 'Address'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (address.isMain) ...[
                          Gap(8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill.r,
                              ),
                            ),
                            child: Text(
                              'Main Address'.tr(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Gap(6.h),
                    Text(
                      address.arabicName ?? address.englishName ?? '',
                      style: details,
                    ),
                    Text(address.customerPhone ?? '', style: details),
                    Gap(4.h),
                    Text(address.customerAddress ?? '', style: details),
                  ],
                ),
              ),
              Icon(
                context.isArabic
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
