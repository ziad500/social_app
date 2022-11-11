abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {
  /*  final ShopLoginModel loginModel;

  ShopRegisterSuccessState(this.loginModel); */
}

class SocialRegisterErrorState extends SocialRegisterStates {
  final String error;

  SocialRegisterErrorState(this.error);
}

class SocialRegisterchangePasswordVisiblilityState
    extends SocialRegisterStates {}

class SocialCreateLoadingState extends SocialRegisterStates {}

class SocialCreateSuccessState extends SocialRegisterStates {
  /*  final ShopLoginModel loginModel;

  ShopCreateSuccessState(this.loginModel); */
}

class SocialCreateErrorState extends SocialRegisterStates {
  final String error;

  SocialCreateErrorState(this.error);
}
