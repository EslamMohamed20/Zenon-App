
import 'package:zenon/models/change_favorites_model.dart';
import 'package:zenon/models/firebase_user_model.dart';
import 'package:zenon/models/login_model.dart';

abstract class HomeStates {}
class HomeInitStates extends HomeStates{}
class HomeChangeBottomNavBarStates extends HomeStates{}


class HomeLoadingdataStates extends HomeStates{}

class HomedataSuccessStates extends HomeStates{}


class HomedataErrorStates extends HomeStates{
  final String error;
  HomedataErrorStates(this.error);
}

class CategoryLoadingdataStates extends HomeStates{}

class CategorydataSuccessStates extends HomeStates{}

class CategorydataErrorStates extends HomeStates{
  final String error;
  CategorydataErrorStates(this.error);
}


class ChangeFavouritesSuccessStates extends HomeStates{
  final ChangeFavouritesModel model ;

  ChangeFavouritesSuccessStates(this.model);
}
class ChangeFavouritesStates extends HomeStates{}  //by force

class ChangeFavouritesErrorStates extends HomeStates{
  final String error;
  ChangeFavouritesErrorStates(this.error);
}



class FavoritesGetLoadingdataStates extends HomeStates{}

class FavoritesGetdataSuccessStates extends HomeStates{}

class FavoritesGetdataErrorStates extends HomeStates{
  final String error;
  FavoritesGetdataErrorStates(this.error);
}


class GetUserDataLoadingStates extends HomeStates{}
class GetUserDataSuccessStates extends HomeStates{
  final LoginModel model ;

  GetUserDataSuccessStates(this.model);
}
class GetUserDataErrorStates extends HomeStates{
  final String error;
  GetUserDataErrorStates(this.error);
}


class GetUserDataFormFirebaseSuccessStates extends HomeStates{
  final FirebaseUserData model ;
  GetUserDataFormFirebaseSuccessStates(this.model);
}

class GetUserDataFormFirebaseErrorStates extends HomeStates{
  final String error;
  GetUserDataFormFirebaseErrorStates(this.error);
}


class UpdateUserDataLoadingStates extends HomeStates{}

class UpdateUserDataSuccessStates extends HomeStates{
  final LoginModel model ;

  UpdateUserDataSuccessStates(this.model);
}

class UpdateUserDataErrorStates extends HomeStates{
  final String error;
 UpdateUserDataErrorStates(this.error);
}


class ThemeChangeSuccessStates extends HomeStates{}

class ProductScreenAddToCartSuccessState extends HomeStates{}
class ProductScreenItemInCartState extends HomeStates{}

class removeItemFromCartProductScreenState extends HomeStates{}




class UploadProductInfoOnFireStoreSuccessState extends HomeStates{}
class UploadProductInfoOnFireStoreLoadingState extends HomeStates{}

class UploadProductInfoOnFireStoreErrorState extends HomeStates{}

class GetImaeSuccessState extends HomeStates{}
class GetImaeLoadingState extends HomeStates{}
class GetImaeErrorState extends HomeStates{
  final String error ;
  GetImaeErrorState(this.error);

}

class GetListOFImageLoadingState extends HomeStates{}

class GetImagesAssetsSuccessState extends HomeStates{}

class GetImagesAssetsErrorState extends HomeStates{}


class UploadImagesToFirebaseStorageAndGetLinkSuccessState extends HomeStates{}
class UploadImagesToFirebaseStorageAndGetLinkLoadingState extends HomeStates{}

class UploadListOfImagesOneByOneToFirebaseStorageAndGetLinkSuccessState extends HomeStates{}
class UploadListOfImagesToFirebaseStorageAndGetLinkLoadingState extends HomeStates{}
class RemoveAllmagesOFProductSuccessState extends HomeStates{}

class UploadListOfImagesToFirebaseStorageAndGetLinkSuccessState extends HomeStates{}


class GetImageFileFromAssetsSuccessState extends HomeStates{}
class GetImageFileFromAssetsAgainSuccessState extends HomeStates{}
class GarpgeState extends HomeStates{}

class GetProjectDataFromFirebaseLoadingState extends HomeStates{}

class GetProjectDataFromFirebaseSuccessState extends HomeStates{}
class GetProjectDataFromFirebaseErrorState extends HomeStates{}


class UpdateUserDataInfoLoadingState extends HomeStates{}
class UpdateUserDataInfoSuccessState extends HomeStates{}
class UpdateUserDataInfoErrorState extends HomeStates{}

class GetAuthsZenonCardsFromFirebaseLoadingState extends HomeStates{}
class GetAuthsZenonCardsFromFirebaseSuccessState extends HomeStates{}
class GetAuthsZenonCardsFromFirebaseErrorState extends HomeStates{}


class GetZenonAdminsFromFirebaseLoadingState extends HomeStates{}
class GetZenonAdminsFromFirebaseSuccessState extends HomeStates{}
class GetZenonAdminsFromFirebaseErrorState extends HomeStates{}

class CheckIfThisUserCardIdFoundInOurDatabaseLoadingState extends HomeStates{}
class CheckIfThisUserCardIdFoundInOurDatabaseSuccessState extends HomeStates{}
class CheckIfThisUserCardIdFoundInOurDatabaseErrorState extends HomeStates{}


class UploadNewZenonCardOnFireStoreLoadingState extends HomeStates{}
class UploadNewZenonCardOnFireStoreSuccessState extends HomeStates{}
class UploadNewZenonCardOnFireStoreErrorState extends HomeStates{}
class CardAllreadyExistOnFireStoreState extends HomeStates{}

class UserAlreadySigninState extends HomeStates{}
class UserNotSigninYetState extends HomeStates{}



class ChangePasswordSignUpVisibilitySuccessState extends HomeStates{}
















