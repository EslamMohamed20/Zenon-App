import 'package:zenon/models/login_model.dart';

abstract class AppSignUpStates {}

class AppSignUpInitState extends  AppSignUpStates {}

class AppSignUpLoadingState extends  AppSignUpStates {}

class AppSignUpSuccesstState extends  AppSignUpStates {
  final LoginModel signUpModel ;
  AppSignUpSuccesstState(this.signUpModel);
  
}

class AppSignUpErrorState extends  AppSignUpStates {
  final String error;
  AppSignUpErrorState(this.error);
}

class UserSignUpWithFirebaseEmailSuccesstState extends  AppSignUpStates {
  final dynamic value;

  UserSignUpWithFirebaseEmailSuccesstState(this.value);
}

class UserSignUpWithFirebaseEmailErrortState extends  AppSignUpStates {
  final dynamic error;
  UserSignUpWithFirebaseEmailErrortState(this.error);
}


class UserSignUpWithFirebaseGoogleSuccesstState extends  AppSignUpStates {
  final dynamic value ;
  UserSignUpWithFirebaseGoogleSuccesstState(this.value);
}

class UserSignUpWithFirebaseGoogleErrorState extends  AppSignUpStates {
  final dynamic error ;
  UserSignUpWithFirebaseGoogleErrorState(this.error);
}

class ChangePasswordSignUpVisibilityState extends  AppSignUpStates {}




class GetImaeLoadingState extends  AppSignUpStates {}

class GetImaeSuccesstState extends  AppSignUpStates { }

class GetImaeErrorState extends  AppSignUpStates {
  final String error;
  GetImaeErrorState(this.error);
}


class UploadImagesToFirebaseStorageAndGetLink extends  AppSignUpStates { }

class UploadImagesToFirebaseStorageAndGetLinkLoadingState extends  AppSignUpStates { }
class UploadImagesToFirebaseStorageAndGetLink2 extends  AppSignUpStates { }
  
