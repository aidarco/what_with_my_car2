part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}


class UserLoginSucces extends AuthState {}
class UserLoginError extends AuthState {

  String error;
  UserLoginError({required this.error});

}

class UserLoginLoading extends AuthState{

}