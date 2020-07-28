import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/bloc/authentication/authentication.dart';
import 'package:geosmart/bloc/position/position_event.dart';
import 'package:geosmart/bloc/position/position_state.dart';
import 'package:geosmart/service/position_service.dart';
import 'package:meta/meta.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  final AuthenticationBloc authenticationBloc;

  PositionBloc({@required this.authenticationBloc})
      : super(PositionTrackingIdle());

  @override
  Stream<PositionState> mapEventToState(PositionEvent event) async* {
    if (event is PositionStartTracking) {
      yield PositionTrackingStarted();
    }
    if (event is PositionStopTracking) {
      try {
        await PositionService(
          dio: authenticationBloc.dio,
        ).stopTracking();
        yield PositionTrackingIdle();
      } catch (e) {
        yield PositionTrackingFailed();
      }
    }
    if (event is PositionSend) {
      try {
        PositionService(
          dio: authenticationBloc.dio,
        ).sendPosition(
          event.lat,
          event.lng,
        );
      } catch (_) {
        await PositionService(
          dio: authenticationBloc.dio,
        ).stopTracking();
        yield PositionTrackingFailed();
      }
    }
  }
}
