// import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/bloc/authentication/authentication_event.dart';
import 'package:geosmart/bloc/authentication/authentication_state.dart';
import 'package:geosmart/service/setting_service.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  // final Alice alice;
  final Dio dio;

  AuthenticationBloc({
    // @required this.alice,
    @required this.dio,
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield AuthenticationProgress();
      final s = await SettingService().getSetting();
      if (s.isValid()) {
        yield AuthenticationSuccess();
      } else {
        yield AuthenticationFailed();
      }
    }

    if (event is AuthenticationClear) {
      await SettingService().clearSetting();
      yield AuthenticationFailed();
    }
  }
}
