import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationProgress extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationFailed extends AuthenticationState {}
