import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_one_test/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:the_one_test/core/constant/constants.dart';
import 'package:the_one_test/core/local/hive_service_impl.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/core/routing/app_router.dart';
import 'package:the_one_test/core/routing/routes.dart';
import 'package:the_one_test/core/services/service_locator/service_locator.dart';
import 'package:the_one_test/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await HiveServiceImpl.init();
  await setup();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useOnlyLangCode: true,
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (_) => getIt<ThemeBloc>(),
      child: ScreenUtilInit(
        designSize: const Size(440, 956),
        splitScreenMode: true,
        ensureScreenSize: true,
        builder: (context, _) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                theme: AppThemeData.light,
                darkTheme: AppThemeData.dark,
                themeMode: themeState.themeMode,

                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,

                scaffoldMessengerKey: scaffoldMessengerKey,
                navigatorKey: navigatorKey,

                debugShowCheckedModeBanner: false,

                onGenerateRoute: AppRouter().generateRoute,
                initialRoute: getIt<UserSessionCache>().isLoggedIn()
                    ? Routes.rootView
                    : Routes.loginView,
              );
            },
          );
        },
      ),
    );
  }
}
