import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../firebase_firestore.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<UserLogin>((event, emit) async{

      try{
        await repo.firebaseAuth(email: event.email, password:  event.password);
       emit(UserLoginSucces());
      }
      catch(e){
        emit(UserLoginError(error: e.toString()));
      };

    });
  }
  final FirebaseFirestore repo;

}
