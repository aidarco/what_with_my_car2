part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}


class UserLogin extends AuthEvent
{
  final String email;
  final String password;
  UserLogin({required this.email, required this.password});
}