import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/config.dart';
import 'package:geosmart/page/map_page.dart';
import 'package:geosmart/page/setting_page.dart';
import 'package:geosmart/page/startup_page.dart';

import 'bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Alice alice = Alice(showNotification: Config.showInterceptor);
  final Dio dio = Dio();
  dio.interceptors.add(alice.getDioInterceptor());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            alice: alice,
            dio: dio,
          )..add(AuthenticationStarted()),
        ),
        BlocProvider<SettingBloc>(
          create: (context) => SettingBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(
              context,
            ),
          ),
        ),
        BlocProvider<PositionBloc>(
          create: (context) => PositionBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(
              context,
            ),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Smart App',
      navigatorKey: BlocProvider.of<AuthenticationBloc>(
        context,
      ).alice.getNavigatorKey(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (ctx, state) {
          if (state is AuthenticationSuccess) {
            return MapPage();
          }
          if (state is AuthenticationFailed) {
            return SettingPage();
          }
          return StartupPage();
        },
      ),
    );
  }
}
