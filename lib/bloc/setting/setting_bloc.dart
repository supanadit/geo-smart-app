import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/bloc/authentication/authentication.dart';
import 'package:geosmart/bloc/setting/setting_event.dart';
import 'package:geosmart/bloc/setting/setting_state.dart';
import 'package:geosmart/model/setting.dart';
import 'package:geosmart/service/setting_service.dart';
import 'package:geosmart/service/unique_id_service.dart';
import 'package:meta/meta.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final AuthenticationBloc authenticationBloc;

  SettingBloc({@required this.authenticationBloc}) : super(SettingInitial());

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is SettingSet) {
      yield SettingProgress();
      if (event.host != null && event.host != "") {
        try {
          final s = await UniqueIDService().getUniqueID(
            event.host,
            authenticationBloc.dio,
          );
          SettingService().setSetting(SettingModel(
            event.host,
            s.id,
          ));
          yield SettingSuccess();
        } catch (_) {
          yield SettingFailed(
            message: "Make sure your host is correct and alive.",
          );
        }
      } else {
        yield SettingFailed(message: "Host cannot null or empty.");
      }
    }
  }
}
