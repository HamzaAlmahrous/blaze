import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blaze/models/user.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({required String email, required String password, required String name, required String phone}){

    emit(RegisterLoadingState());
    
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
    .then((value){
      userCreate(email: email, uId: value.user!.uid, name: name, phone: phone);
    })
    .catchError((error){
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
    
  }

  void userCreate({required String email, required String uId, required String name, required String phone}){

    SocialUser user = SocialUser(
      followers: 0,
      email: email, 
      uId: uId, 
      name: name, 
      phone: phone, 
      image: 'https://cbcs.ac.in/wp-content/uploads/2020/10/placeholder.jpg',
      bio: 'write you bio ...',
      cover: 'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
    );
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .set(user.toJson())
    .then((value){ 
      emit(CreateUserSuccessState(uId));
    })
    .catchError((error){
      emit(CreateUserErrorState(error.toString()));
    });

  }

  IconData suffix = Icons.visibility_outlined;
  bool showPassword = true;

  void changePasswordVisibility() {
    showPassword = !showPassword;

    suffix = showPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(RegisterePasswordVisisbilityState());
  }
}
