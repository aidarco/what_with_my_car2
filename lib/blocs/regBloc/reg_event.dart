part of 'reg_bloc.dart';

@immutable
abstract class RegEvent {}

class UserReg extends RegEvent {

  final String email;
  final String password;

  UserReg({required this.email, required this.password});
}
