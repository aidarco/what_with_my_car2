import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repos/firebase_firestore.dart';

part 'reg_event.dart';

part 'reg_state.dart';

class RegBloc extends Bloc<RegEvent, RegState> {
  RegBloc({required this.repo}) : super(RegInitial()) {
    on<UserReg>((event, emit) async {


      try {
        await repo.firebaseReg(email: event.email, password: event.password);
        emit(RegSucces());
      } catch (e) {
        emit(RegError(error: e.toString()));
      }
    });



  }
  final Firebasefirestore repo;
}
