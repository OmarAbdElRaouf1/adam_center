import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/auth/presentation/manager/district_bloc/district_bloc.dart';
import 'package:the_one_test/features/auth/presentation/manager/governorate_bloc/governorate_bloc.dart';
import 'package:the_one_test/features/auth/presentation/widgets/custom_drop_down.dart';

class LocationDropdowns extends StatelessWidget {
  const LocationDropdowns({super.key, required this.onSelectionChanged});

  final void Function(GovernorateModel? governorate, DistrictModel? district)
  onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<GovernorateBloc>()..add(const GetGovernoratesEvent()),
        ),
        BlocProvider(create: (context) => getIt<DistrictBloc>()),
      ],
      child: _LocationDropdownsView(onSelectionChanged: onSelectionChanged),
    );
  }
}

class _LocationDropdownsView extends StatefulWidget {
  const _LocationDropdownsView({required this.onSelectionChanged});

  final void Function(GovernorateModel? governorate, DistrictModel? district)
  onSelectionChanged;

  @override
  State<_LocationDropdownsView> createState() => _LocationDropdownsViewState();
}

class _LocationDropdownsViewState extends State<_LocationDropdownsView> {
  GovernorateModel? selectedGovernorate;
  DistrictModel? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GovernorateBloc, BaseState<GovernorateModel>>(
      builder: (context, governorateState) {
        return Column(
          children: [
            CustomDropdown(
              hint: governorateState.isLoading
                  ? 'Loading...'.tr()
                  : 'Select Government'.tr(),
              value: selectedGovernorate?.name,
              items: governorateState.items.map((g) => g.name).toList(),
              onChanged: (value) => setState(() {
                selectedGovernorate = governorateState.items.firstWhere(
                  (g) => g.name == value,
                );
                selectedDistrict = null;
                context.read<DistrictBloc>().add(
                  GetDistrictsByGovernorateEvent(selectedGovernorate!.id),
                );
                widget.onSelectionChanged(selectedGovernorate, null);
              }),
            ),
            Gap(16.h),
            BlocBuilder<DistrictBloc, BaseState<DistrictModel>>(
              builder: (context, districtState) {
                return CustomDropdown(
                  hint: districtState.isLoading
                      ? 'Loading...'.tr()
                      : 'Select District'.tr(),
                  value: selectedDistrict?.name,
                  items: districtState.items.map((d) => d.name).toList(),
                  onChanged: (value) => setState(() {
                    selectedDistrict = districtState.items.firstWhere(
                      (d) => d.name == value,
                    );
                    widget.onSelectionChanged(
                      selectedGovernorate,
                      selectedDistrict,
                    );
                  }),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
