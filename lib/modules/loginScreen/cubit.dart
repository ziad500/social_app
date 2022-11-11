import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/modules/loginScreen/states.dart';
import 'package:social_app/shared/components/components.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());
  //ShopLoginModel? loginmodel;

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password}) async {
    emit(SocialLoginLoadingState());

    try {
      var value = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(SocialLoginSuccessState(value.user!.uid));
    } on FirebaseAuthException catch (e) {
      showToast(text: e.message, state: ToastStates.ERROR);
      emit(SocialLoginErrorState(e.toString()));
    }
  }

  bool isVisible = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisiblility() {
    isVisible = !isVisible;

    suffix =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialchangePasswordVisiblilityState());
  }
}
