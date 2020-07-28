import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class SettingSet extends SettingEvent {
  final String host;

  const SettingSet({@required this.host}) : assert(host != null && host != "");

  @override
  List<Object> get props => [];

  @override
  String toString() => "SettingSet { host: $host }";
}

class SettingClear extends SettingEvent {}
