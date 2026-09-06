import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/account/presentation/widgets/account_action_buttons.dart';
import 'package:the_one_test/features/account/presentation/widgets/account_info_fields.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _controllersHydrated = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _hydrateControllers(UserModel? user) {
    if (_controllersHydrated) return;
    _controllersHydrated = true;
    firstNameController.text = user?.englishName ?? '';
    lastNameController.text = user?.lastName ?? '';
    phoneController.text = user?.customerPhone ?? '';
    emailController.text = user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountCubit>(),
      child: BlocBuilder<AccountCubit, UserModel?>(
        builder: (context, user) {
          _hydrateControllers(user);
          return Scaffold(
            key: ValueKey(context.locale.languageCode),
            appBar: const CustomAppBar(titleText: 'My Account'),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountInfoFields(
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                      phoneController: phoneController,
                      emailController: emailController,
                    ),
                    Gap(32.h),
                    const AccountActionButtons(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
