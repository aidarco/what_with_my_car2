part of 'reg_bloc.dart';

@immutable
abstract class RegState {}

class RegInitial extends RegState {}

class RegSucces extends RegState{}

class RegError extends RegState{


  String error;
  RegError({required this.error});

}

class RegLoading extends RegState{}