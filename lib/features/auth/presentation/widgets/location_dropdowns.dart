import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/auth/presentation/manager/district_bloc/district_bloc.dart';
import 'package:the_one_test/features/auth/presentation/manager/governorate_bloc/governorate_bloc.dart';
import 'package:the_one_test/features/auth/presentation/widgets/custom_drop_down.dart';

class LocationDropdowns extends StatelessWidget {
  const LocationDropdowns({
    super.key,
    required this.onSelectionChanged,
    this.governorateLabel,
    this.districtLabel,
    this.initialGovernorateName,
    this.initialDistrictName,
  });

  final void Function(GovernorateModel? governorate, DistrictModel? district)
  onSelectionChanged;

  /// Optional captions shown above each dropdown (with a required mark).
  final Widget? governorateLabel;
  final Widget? districtLabel;

  /// Preselected by name once the lists load (e.g. from a saved address).
  final String? initialGovernorateName;
  final String? initialDistrictName;

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
      child: _LocationDropdownsView(widget: this),
    );
  }
}

class _LocationDropdownsView extends StatefulWidget {
  const _LocationDropdownsView({required this.widget});

  final LocationDropdowns widget;

  @override
  State<_LocationDropdownsView> createState() => _LocationDropdownsViewState();
}

class _LocationDropdownsViewState extends State<_LocationDropdownsView> {
  GovernorateModel? selectedGovernorate;
  DistrictModel? selectedDistrict;
  bool _appliedInitialGovernorate = false;
  bool _appliedInitialDistrict = false;

  LocationDropdowns get config => widget.widget;

  void _selectGovernorate(GovernorateModel governorate) {
    setState(() {
      selectedGovernorate = governorate;
      selectedDistrict = null;
    });
    context.read<DistrictBloc>().add(
      GetDistrictsByGovernorateEvent(governorate.id),
    );
    config.onSelectionChanged(governorate, null);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GovernorateBloc, BaseState<GovernorateModel>>(
          listenWhen: (_, state) => state.isSuccess,
          listener: (context, state) {
            if (_appliedInitialGovernorate) return;
            _appliedInitialGovernorate = true;
            final name = config.initialGovernorateName;
            final match = state.items.where((g) => g.name == name);
            if (name != null && match.isNotEmpty) {
              _selectGovernorate(match.first);
            }
          },
        ),
        BlocListener<DistrictBloc, BaseState<DistrictModel>>(
          listenWhen: (_, state) => state.isSuccess,
          listener: (context, state) {
            if (_appliedInitialDistrict) return;
            _appliedInitialDistrict = true;
            final name = config.initialDistrictName;
            final match = state.items.where((d) => d.name == name);
            if (name != null && match.isNotEmpty) {
              setState(() => selectedDistrict = match.first);
              config.onSelectionChanged(selectedGovernorate, match.first);
            }
          },
        ),
      ],
      child: BlocBuilder<GovernorateBloc, BaseState<GovernorateModel>>(
        builder: (context, governorateState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (config.governorateLabel != null) ...[
                config.governorateLabel!,
                Gap(10.h),
              ],
              CustomDropdown(
                key: ValueKey('gov-${selectedGovernorate?.name}'),
                hint: governorateState.isLoading
                    ? 'Loading...'.tr()
                    : 'Select Government'.tr(),
                value: selectedGovernorate?.name,
                items: governorateState.items.map((g) => g.name).toList(),
                onChanged: (value) => _selectGovernorate(
                  governorateState.items.firstWhere((g) => g.name == value),
                ),
              ),
              Gap(16.h),
              if (config.districtLabel != null) ...[
                config.districtLabel!,
                Gap(10.h),
              ],
              BlocBuilder<DistrictBloc, BaseState<DistrictModel>>(
                builder: (context, districtState) {
                  return CustomDropdown(
                    key: ValueKey(
                      'district-${selectedGovernorate?.name}-'
                      '${selectedDistrict?.name}',
                    ),
                    hint: districtState.isLoading
                        ? 'Loading...'.tr()
                        : 'Select District'.tr(),
                    value: selectedDistrict?.name,
                    items: districtState.items.map((d) => d.name).toList(),
                    onChanged: (value) => setState(() {
                      selectedDistrict = districtState.items.firstWhere(
                        (d) => d.name == value,
                      );
                      config.onSelectionChanged(
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
      ),
    );
  }
}
