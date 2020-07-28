import 'package:equatable/equatable.dart';

class PositionEvent extends Equatable {
  const PositionEvent();

  @override
  List<Object> get props => [];
}

class PositionStartTracking extends PositionEvent {}

class PositionSend extends PositionEvent {
  final String lat;
  final String lng;

  const PositionSend({this.lat, this.lng});

  @override
  List<Object> get props => [this.lat, this.lng];

  @override
  String toString() => "PositionSend { lat: $lat, lng: $lng }";
}

class PositionStopTracking extends PositionEvent {}
