import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/register_screen/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  /* ShopLoginModel? loginModel;
 */
  void userRegister(
      {required String name,
      required String phone,
      required String email,
      required String password}) async {
    emit(SocialRegisterLoadingState());

    /*   FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(
          name: name,
          phone: phone,
          email: email,
          password: password,
          uId: FirebaseAuth.instance.currentUser!.uid);
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    }); */

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      userCreate(
          name: name,
          phone: phone,
          email: email,
          password: password,
          uId: FirebaseAuth.instance.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      showToast(text: e.message, state: ToastStates.ERROR);

      emit(SocialRegisterErrorState(e.toString()));
    }
  }

  bool isVisible = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisiblility() {
    isVisible = !isVisible;

    suffix =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterchangePasswordVisiblilityState());
  }

  void userCreate(
      {required String name,
      required String phone,
      required String email,
      required String uId,
      required String password}) async {
    emit(SocialRegisterLoadingState());
    try {
      await FirebaseFirestore.instance.collection('users').doc(uId).set(UserModel(
              email: email,
              name: name,
              passsord: password,
              phone: phone,
              uId: uId,
              isEmailVerified: false,
              bio: 'write your bio ... ',
              cover:
                  'https://img.freepik.com/premium-photo/school-classroom-with-chairsdesks-chalkboard_258219-255.jpg?w=1060',
              image:
                  'https://img.freepik.com/free-photo/shocked-curly-haired-woman-keeps-hands-cheeks-stares-bugged-eyes-camera-has-surprised-exression-holds-breath-wears-casual-blue-jumper-isolated-pink-background-human-reactions-concept_273609-59468.jpg?t=st=1659889215~exp=1659889815~hmac=2894acd4791c6512cb11c47781ef5cda33f6e30ad07feffa978b344961af1494')
          .toMap());
      emit(SocialCreateSuccessState());
    } catch (e) {
      print('error is $e');
      emit(SocialCreateErrorState(e.toString()));
    }
  }
}
