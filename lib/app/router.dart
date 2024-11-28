import 'package:calendar/screens/auth_screen/auth_screen.dart';
import 'package:calendar/screens/home_screen/home_screen.dart';
import 'package:calendar/screens/register_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:calendar/screens/login_screen/login_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
        ),
        AutoRoute(
          page: RegisterRoute.page,
        ),
        AutoRoute(
          page: AuthRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: HomeRoute.page,
        )
      ];
}
