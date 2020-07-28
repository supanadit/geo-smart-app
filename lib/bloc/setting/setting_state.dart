import 'package:equatable/equatable.dart';

class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class SettingProgress extends SettingState {}

class SettingSuccess extends SettingState {}

class SettingFailed extends SettingState {
  final String message;

  const SettingFailed({this.message});

  @override
  List<Object> get props => [this.message];

  @override
  String toString() => "SettingFailed { message: $message }";
}
