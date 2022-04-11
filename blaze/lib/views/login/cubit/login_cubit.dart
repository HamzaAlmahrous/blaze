import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password}) async {
    emit(SocialLoginLoadingState());

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        emit(SocialLoginSuccessState(value.user!.uid));
      }).catchError((error) {
        print(error.toString());
        emit(SocialLoginErrorState(error.toString()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  IconData suffix = Icons.visibility_outlined;
  bool showPassword = true;

  void changePasswordVisibility() {
    showPassword = !showPassword;

    suffix = showPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(SocialChangePasswordVisisbilityState());
  }
}
