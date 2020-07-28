import 'package:equatable/equatable.dart';

class PositionState extends Equatable {
  const PositionState();

  @override
  List<Object> get props => [];
}

class PositionTrackingIdle extends PositionState {}

class PositionTrackingFailed extends PositionState {}

class PositionTrackingStarted extends PositionState {}
