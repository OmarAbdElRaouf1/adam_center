import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/presentation/manager/signup_bloc/signup_bloc.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_header.dart';
import 'package:the_one_test/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:the_one_test/features/auth/presentation/widgets/lanuage_toggle.dart';
import 'package:the_one_test/features/auth/presentation/widgets/signup_form.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      headerHeightFactor: 0.38.h,
      header: AuthHeader(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Sign Up'.tr(),
        subtitle: 'Join us and start your journey'.tr(),
        iconSize: 34,
        titleFontSize: 27,
        iconBoxRadius: 22,
        iconBoxBordered: true,
        topRow: Align(
          alignment: AlignmentDirectional.topEnd,
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: 8.h, end: 16.w),
            child: LanguageToggle(),
          ),
        ),
      ),
      formCard: AuthFormCard(
        borderRadius: 28,
        padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 24.h),
        shadowBlur: 30,
        shadowOffset: Offset(0, 12.h),
        child: BlocProvider(
          create: (context) => getIt<SignupBloc>(),
          child: const SignupForm(),
        ),
      ),
    );
  }
}
