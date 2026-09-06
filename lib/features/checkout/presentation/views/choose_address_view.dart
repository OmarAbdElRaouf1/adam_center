import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/core/widgets/empty_state_widget.dart';
import 'package:the_one_test/core/widgets/failure_widget.dart';
import 'package:the_one_test/core/widgets/shimmer_skeletons.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/checkout/data/datasource/add_address_datasource.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';
import 'package:the_one_test/features/checkout/presentation/views/add_address_view.dart';

class ChooseAddressView extends StatefulWidget {
  const ChooseAddressView({super.key});

  @override
  State<ChooseAddressView> createState() => _ChooseAddressViewState();
}

class _ChooseAddressViewState extends State<ChooseAddressView> {
  late Future<Either<Failure, List<Map<String, dynamic>>>> _future;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    _future = getIt<AddAddressDatasource>().getAddresses();
  }

  Future<void> _selectAddress(Map<String, dynamic> address) async {
    final accountCubit = getIt<AccountCubit>();
    final currentUser = accountCubit.state;
    if (currentUser != null) {
      await accountCubit.updateUser(
        currentUser.copyWith(
          regionId: address['region_id'] as int?,
          regionName: address['RegionName'] as String?,
          districtName: address['DistrictName'] as String?,
          streetName: address['StreetName'] as String?,
          houseNo: address['HouseNo'] as String?,
          block: address['Block'] as String?,
          floor: address['Floor'] as String?,
          apartment: address['Apartment'] as String?,
          addressNotes: address['AddressNotes'] as String?,
          customerAddress: address['CustomerAddress'] as String?,
          addressId: address['AddressID']?.toString(),
        ),
      );
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _addNewAddress() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressView()),
    );
    if (added == true && mounted) {
      setState(_loadAddresses);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        onTap: _addNewAddress,
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
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              Gap(16.h),
              Expanded(
                child: FutureBuilder<Either<Failure, List<Map<String, dynamic>>>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const ListRowShimmer(itemCount: 3);
                    }
                    final result = snapshot.data;
                    if (result == null) return const SizedBox.shrink();
                    return result.fold(
                      (failure) => FailureWidget(
                        state: BaseState(errorMessage: failure.message),
                        errorMessage: failure.message,
                        onRetry: () => setState(_loadAddresses),
                      ),
                      (addresses) {
                        if (addresses.isEmpty) {
                          return EmptyStateWidget(
                            icon: Icons.location_off_outlined,
                            message: 'No saved addresses yet'.tr(),
                          );
                        }
                        return ListView.separated(
                          itemCount: addresses.length,
                          separatorBuilder: (_, _) => Gap(14.h),
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            final isMain = address['MainAddress'] == 1;
                            return InkWell(
                              onTap: () => _selectAddress(address),
                              borderRadius: BorderRadius.circular(
                                AppRadius.card.r,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.card.r,
                                  ),
                                  border: Border.all(
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryColor,
                                    ),
                                    Gap(10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            districtFromCustomerAddress(
                                                  address['CustomerAddress']
                                                      as String?,
                                                ) ??
                                                'Address'.tr(),
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          if (isMain) ...[
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
                                            address['ArabicName']
                                                    as String? ??
                                                address['EnglishName']
                                                    as String? ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 13.5.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            address['CustomerPhone']
                                                    as String? ??
                                                '',
                                            style: TextStyle(fontSize: 13.sp),
                                          ),
                                          Gap(4.h),
                                          Text(
                                            address['CustomerAddress']
                                                    as String? ??
                                                '',
                                            style: TextStyle(fontSize: 12.5.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
    );
  }
}
