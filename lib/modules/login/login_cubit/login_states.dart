
import 'package:zenon/models/login_model.dart';

abstract class AppLoginStates {}

class AppLoginInitState extends  AppLoginStates {}

class AppLoginLoadingState extends  AppLoginStates {}

class AppLoginSuccesstState extends  AppLoginStates {
  final LoginModel loginModel ;
  AppLoginSuccesstState(this.loginModel);
}

class AppLoginErrorState extends  AppLoginStates {
  final String error;
  AppLoginErrorState(this.error);
}



class UserLoginWithFirebaseEmailSuccesstState extends  AppLoginStates {
  final dynamic value ;
  UserLoginWithFirebaseEmailSuccesstState(this.value);
}

class UserLoginWithFirebaseEmailErrorState extends  AppLoginStates {
  final dynamic error ;
  UserLoginWithFirebaseEmailErrorState(this.error);
}

class UserLoginWithFirebaseEmailLoadingState extends  AppLoginStates {
}


class UserLoginWithFirebaseGoogleSuccesstState extends  AppLoginStates {
  final dynamic value ;
  UserLoginWithFirebaseGoogleSuccesstState(this.value);
}

class UserLoginWithFirebaseGoogleErrorState extends  AppLoginStates {
  final dynamic error ;
  UserLoginWithFirebaseGoogleErrorState(this.error);
}

class UserLoginWithFirebaseGoogleLoadingState extends  AppLoginStates {
}

class FetchDataAfterLoginLoadingState extends  AppLoginStates {}
class FetchDataAfterLoginSuccessState extends  AppLoginStates {}


class ChangePasswordVisibilityState extends  AppLoginStates {}



class GetGestInfoFromFirebaseErrorState extends  AppLoginStates {}
class GetGestInfoFromFirebaseSuccessState extends  AppLoginStates {}
class GetGestInfoFromFirebaseLoadingState extends  AppLoginStates {}

