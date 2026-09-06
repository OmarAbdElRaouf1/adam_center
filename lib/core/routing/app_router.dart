import 'package:flutter/material.dart';
import 'package:the_one_test/features/auth/presentation/views/login_view.dart';
import 'package:the_one_test/features/auth/presentation/views/signup_view.dart';
import 'package:the_one_test/features/home/presentation/views/home_view.dart';
import 'package:the_one_test/features/home/presentation/views/root_view.dart';

import 'routes.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginView:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.signUpView:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case Routes.rootView:
        return MaterialPageRoute(builder: (_) => const RootView());
      case Routes.homeView:
        return MaterialPageRoute(builder: (_) => const HomeView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for "${settings.name}"'),
            ),
          ),
        );
    }
  }
}
