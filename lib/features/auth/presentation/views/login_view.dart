import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/presentation/manager/login_bloc/login_bloc.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_header.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:the_one_test/features/auth/presentation/widgets/lanuage_toggle.dart';
import 'package:the_one_test/features/auth/presentation/widgets/login_form.dart';
import 'package:the_one_test/features/auth/presentation/widgets/theme_toggle_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      header: AuthHeader(
        icon: Icons.lock_outline,
        title: 'Login'.tr(),
        subtitle: 'Join us and start your journey'.tr(),
        topRow: Align(
          alignment: AlignmentDirectional.topEnd,
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: 12.h, end: 16.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [ThemeToggleButton(), Gap(8.w), LanguageToggle()],
            ),
          ),
        ),
      ),
      formCard: AuthFormCard(
        child: BlocProvider(
          create: (context) => getIt<LoginBloc>(),
          child: LoginForm(),
        ),
      ),
    );
  }
}
