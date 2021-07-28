import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:zenon/models/categories_model.dart';
import 'package:zenon/models/change_favorites_model.dart';
import 'package:zenon/models/favoritites_model.dart';
import 'package:zenon/models/firebase_product_model.dart';
import 'package:zenon/models/firebase_user_model.dart';
import 'package:zenon/models/login_model.dart';
import 'package:zenon/models/products_model.dart';
import 'package:zenon/models/products_model.dart' as Product2;
import 'package:zenon/models/zenon_admin_model.dart';
import 'package:zenon/models/zenon_card_model.dart';
import 'package:zenon/modules/by_me_user/by_me_cubit/by_me_cubit.dart';
import 'package:zenon/modules/by_me_user/by_me_screen.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/modules/catigories/categories_screen.dart';
import 'package:zenon/modules/catigories/inner_screens/brands_navigation_rail_screen.dart';
import 'package:zenon/modules/favourites/favourites_screen.dart';
import 'package:zenon/modules/products/products_screen.dart';
import 'package:zenon/modules/settings/settings_screen.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/network/local/cacheHelper.dart';
import 'package:zenon/shared/network/remote/dio_helper.dart';
import 'package:zenon/shared/network/remote/end_points_urls/end_points.dart';
import 'package:path_provider/path_provider.dart';

import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitStates()); //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
  static HomeCubit get(context) =>
      BlocProvider.of(context); // CounterCubit.get(context).توصل لاى حاجه جوه

//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها

  // bool isDark = isdarkTheme ;
  
  String scanBarcodeResult ; 

  void themeChange (bool value) {
    isdarkTheme = value ;
     CacheHelper.saveData(key:'isDark', value: value);
     //print (isDark) ;
     emit(ThemeChangeSuccessStates());
  }

  void getDarkTheme () {
    isdarkTheme = CacheHelper.getData(key:'isDark')??false;
  }
  int navCurrentIndex = 0;
  //ماتلعبش ف ترتيبهم
  List<Widget> bottomNavBarScreens = [
    ProductsScreen(), //home screen
    CategoriesScreen(),
    FavouritesScreen(),
    ByMeScreen(),
    SettingScreen(),
  ];

  Map<int, bool> favourites = {};

  void changeBottomNavSreens(int index) {
    navCurrentIndex = index;
    emit(HomeChangeBottomNavBarStates());
  }

  HomeModel homeModel;

  //homeModelFromJson(jsonString); -------------------------------------
  void getHomeData() {
   // userToken = CacheHelper.getData(key: 'token');
    emit(HomeLoadingdataStates());
    DioHelper.getData(
      url: HOME,
      token: userToken,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favourites.addAll({element.id: element.inFavorites});
      });

   //   print(favourites.toString());
      emit(HomedataSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(HomedataErrorStates(error.toString()));
    });
  }

//categories ----------------------------------------------------
   
   CategoriesModel categoriesModel ;
    
  void getcategoriesData() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      //  token: userToken,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      categoriesModelConst = categoriesModel ;
      emit(CategorydataSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(CategorydataErrorStates(error.toString()));
    });
  }

//favouries---------------------------------------------------
//اضافة او حذف مفضل
//endpoint :FAVORITES
  ChangeFavouritesModel changeFavouritesModel ;

  void changeFavourites(int productId) {
    favourites[productId] = !favourites[productId];    //علشان اقدر اتحكم ف اضاءة زر المفضلات لحظيا
      emit(ChangeFavouritesStates());

    DioHelper.postData(posturl: FAVORITES,
     token: userToken,
     postData: 
          {"product_id": productId},
     )
        .then((value) {
          changeFavouritesModel = ChangeFavouritesModel.fromjson(value.data);
        //  print(value.data);

          if(!changeFavouritesModel.stutus)      //علشان لو حصل اى ايرور ف السيرفر
          {
            favourites[productId] = !favourites[productId];
          }else {
            getFavoritesData();                        //علشان تتشال لاحظيا من قائمة المفضلات
          }
          emit(ChangeFavouritesSuccessStates(changeFavouritesModel));
        })
        .catchError((error){
          favourites[productId] = !favourites[productId];
          print(error.toString());
          emit(ChangeFavouritesErrorStates(error.toString()));
        });
  }
//--------------------------------------------------------
//get favouriets data
//endpoint :FAVORITES
  FavoritesModel favouritesModel ;
  Future <void> getFavoritesData() {   
      
  // userToken = CacheHelper.getData(key: 'token');     
    emit(FavoritesGetLoadingdataStates());
    print('from fav : $userToken');   
    DioHelper.getData(
      url: FAVORITES,
      token: userToken,
    ).then((value) {
      favouritesModel = FavoritesModel.fromJson(value.data);
       emit(FavoritesGetdataSuccessStates());
      return value;
     // printFullText(value.data.toString());
     
    }).catchError((error) {
      print(error.toString());
      emit(FavoritesGetdataErrorStates(error.toString()));
      return error;
      
    });
  }
//-------------------------------------------------------

//Get profileData 
//endpoint:PROFILE
final FirebaseAuth _auth = FirebaseAuth.instance;
//_auth.currentUser.
LoginModel userModel ;

  void getUserData() {
   //userToken = CacheHelper.getData(key: 'token');
    emit(GetUserDataLoadingStates());
    DioHelper.getData(
      url: PROFILE,
     token: userToken,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(value.data);
      emit(GetUserDataSuccessStates(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorStates(error.toString()));
    });
  }

//get user data from firebase----------------
DocumentSnapshot userDoc ;
FirebaseUserData userModlInfo;
getUserDataFromFirebase ()async {
  emit(GetUserDataLoadingStates()) ;
    User user = _auth.currentUser;
  // userModlInfo.firebaseUserID=user.uid;
    print ('id: ${user.uid}');
  
 if(user.uid !=null)
  {  
   

    await FirebaseFirestore.instance.collection('users')
.doc(user.uid).get().then((value)
{
   userModlInfo = FirebaseUserData.fromJson(value.data()); 
   print(userModlInfo.email);
  user.updateDisplayName(userModlInfo.name);
  user.updatePhotoURL(userModlInfo.image);
   user.reload();
   print ('photoURL: ${user.photoURL}');
   print ('displayName: ${user.displayName}');
   emit(GetUserDataFormFirebaseSuccessStates(userModlInfo));
   return userDoc =value;
 
}).catchError((error){
  print(error.toString());
  //userModel = LoginModel.fromJson(null);
   emit(GetUserDataFormFirebaseErrorStates(error));
  });
  }
  else print('uid = null');
}

 bool isSignin=false ;
checkIfUserLogInOrGest(){
  if(!_auth.currentUser.isAnonymous &&_auth.currentUser.uid !='cmE3SXGZywfH9F036SOOUclH0Ox1' )
  {
     isSignin=true ;
     emit(UserAlreadySigninState());
  }
  else{
    isSignin=false ;
     emit(UserNotSigninYetState());
  }
}

updateUserDataOnFirebase({
  String name ,
 String phoneNumber ,
String zenonCardId ,
String creditCardID,
String imageUrl , 
String adress_1,
String adress_2,
})async {
  emit(UpdateUserDataInfoLoadingState());
   User user = _auth.currentUser;
   await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
     
     'name':name ??userModlInfo.name ,
     'phoneNumber' : phoneNumber?? userModlInfo.phone ,
     'zenonCardId':zenonCardId??userModlInfo.zenonCardId,
     'creditCardID':creditCardID ??userModlInfo.creditCardID ,
     'imageUrl':imageUrl??userModlInfo.image ,
     'adress1':adress_1 ??userModlInfo.adress_1,
     'adress2':adress_2 ??userModlInfo.adress_2,
   }).then((value) {
     emit(UpdateUserDataInfoSuccessState());
   }).catchError((error)
   {
     print('when updatte user info $error');
    emit(UpdateUserDataInfoErrorState());


   });
}

List<ZenonAdminModel> zenonAdmins =[];

getZenonAdminsFromFirebase( )async {
  emit(GetZenonAdminsFromFirebaseLoadingState());
await FirebaseFirestore.instance.collection('zenonAdmins')
.get().then((admins) {
  zenonAdmins=[];
   print ('iam in Zenon Cards now');
  admins.docs.forEach((element) {
    zenonAdmins.add(ZenonAdminModel.fromJson(element.data()));
   });
   print('from zenon admins : ${zenonAdmins[0].adminName}');
   emit(GetZenonAdminsFromFirebaseSuccessState());  
}).catchError((error){
  print ('from zenonAdmins error : $error');
   emit(GetZenonAdminsFromFirebaseErrorState());
});

}
 

List<ZenonCardModel> zenonCards =[];
//String userZenonCardId ;
getAuthsZenonCardsFromFirebase( )async {
  emit(GetAuthsZenonCardsFromFirebaseLoadingState());
await FirebaseFirestore.instance.collection('zenonCard')
.get().then((cards) {
  zenonCards=[];
   print ('iam in Zenon Cards now');
  cards.docs.forEach((element) {
    zenonCards.add(ZenonCardModel.fromJson(element.data()));
   });
   print('from zenon card : ${zenonCards[0].cardId}');
   emit(GetAuthsZenonCardsFromFirebaseSuccessState());  
}).catchError((error){
  print ('from zenonCards error : $error');
   emit(GetAuthsZenonCardsFromFirebaseErrorState());
});

}
 
 
  bool isCardExistGlobal =false;
  checkIfThisUserCardIdFoundInOurDatabase(String userZenonCardId )
 {  
  emit(CheckIfThisUserCardIdFoundInOurDatabaseLoadingState());
  bool iscardExist = false ;

  zenonCards.forEach((card) {
    if(card.cardId.toString().toLowerCase().trim() == userZenonCardId.toString().toLowerCase().trim()  )
    {
      iscardExist=true ;
       isCardExistGlobal=true;
    }
   });
 iscardExist?emit(CheckIfThisUserCardIdFoundInOurDatabaseSuccessState()) :
 emit(CheckIfThisUserCardIdFoundInOurDatabaseErrorState());

}

var uuid = Uuid();

uploadNewZenonCardOnFireStore(
  {@required String cardId,
  String userName,
   String userPhone,
  double cashAmount,
}
) async{
  emit(UploadNewZenonCardOnFireStoreLoadingState());
  await getAuthsZenonCardsFromFirebase();
   checkIfThisUserCardIdFoundInOurDatabase(cardId);

  if(!isCardExistGlobal) {
    await FirebaseFirestore.instance.collection('zenonCard')
  .doc(uuid.v4())
  .set({
     'cardId': cardId ,
     'cashAmount':cashAmount??10.0,
     'userName':userName??'unknown',
     'userPhone':userPhone??'unknown',
  }).then((value) {
    emit(UploadNewZenonCardOnFireStoreSuccessState());
  }).catchError((error){
    print('when upload New Card : $error');
    UploadNewZenonCardOnFireStoreErrorState();
  });

 }
  else 
  {
    emit(CardAllreadyExistOnFireStoreState());
  }
  
}

//upload product on firebase---------------------
Future <void> uploadProductInfoOnFireStore({
  @required String productId, // serial num
  @required  String tagId ,
  @required double price,
  double oldPrice = 0.0,
  @required String image,
  @required  String name,
  String categoryName,
  String prandName,
  @required  int quantatity,
  @required  String description,
  @required  List<String> images,
    bool inFavorites , 
    bool inCart,
}) async
{
  emit (UploadProductInfoOnFireStoreLoadingState());
  var date = DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
  final User user = _auth.currentUser;
  final _uid  = user.uid; // userUploadId 
  final firebaseId = uuid.v4();
  await FirebaseFirestore.instance.collection('products').doc(firebaseId ).
  set({
   'productId':productId ,
   'firebaseId': firebaseId ,
   'userUploadId':_uid,
    'tagId' : tagId ,
    'name':name ,
    'image' : image ??'https://firebasestorage.googleapis.com/v0/b/zenon1.appspot.com/o/products%2Findmmex.jpg?alt=media&token=ed458dfd-cad3-4bbb-8fa8-6edb2da52ed7' ,
    'images' : images??[] ,
    'price' : price ,
    'oldPrice' : oldPrice??0.0,
    'categoryName': categoryName??'accessories' ,
    'prandName':prandName??'accessories',
    'quantatity':quantatity ,
    'description':description ,
     'inFavorites':inFavorites??false,
     'inCart':inCart??false,
    'createdAt':formattedDate,
  }).then((value) {
    emit (UploadProductInfoOnFireStoreSuccessState());
  }).catchError((error){
    print('upload product to firestor error: $error');
    emit(UploadProductInfoOnFireStoreErrorState());
  });

 
}


//getProjectDataFromFirebase--------------------------------------
//FirebaseProductModel firebaseProductInfo ;
List<FirebaseProductModel> firebaseProductInfo =[];
 getProductDataFromFirebase() async{
   emit(GetProjectDataFromFirebaseLoadingState());
  await FirebaseFirestore.instance.collection('products')
  .get()
  .then((QuerySnapshot productsSnapshot) {
    firebaseProductInfo =[];
    print ('iam in product now');
    productsSnapshot.docs.forEach((element) { 
      firebaseProductInfo.add(FirebaseProductModel.fromJson(element.data()));
    });
    print ('products from firebase:  ${firebaseProductInfo[1].name}');
     emit(GetProjectDataFromFirebaseSuccessState());
  }).catchError((error) {
    print(error);
    emit(GetProjectDataFromFirebaseErrorState());
  });
 }

//---------------------------------------------------------

//Update profile
//LoginModel userModel  ...نفس بتاع البروفايل ان لانه بيعدل عليه
  void updateUserData(
    {
      @required String name,
      @required String phone,
      @required String email,
       String password,
       String image,
    }) {
       emit(UpdateUserDataLoadingStates());
       DioHelper.putData(
      puturl:UPDATEPROFILE,
       putData: 
       {
        'name': name ,
        'phone': phone ,
        'email': email ,
        'password': password ,
        'image': image ,
       } ,
       token: userToken,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
    //  print(value.data);
      emit(UpdateUserDataSuccessStates(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserDataErrorStates(error.toString()));
    });
  }

  //================================

  addToCartState ()
   {
     emit(ProductScreenAddToCartSuccessState());
   }

   removeItemFromCartProductScreen()
   {
     emit(removeItemFromCartProductScreenState());
   }

  productScreencheckItemInCart(String id , BuildContext context) {
   if (CartCubit.get(context).cartItems.containsKey(id)) {
   emit(ProductScreenItemInCartState());
}
}


Product2.Product findProductById(int productId ) {
    return homeModel.data.products.firstWhere((element) => element.id== productId);
  }

//---------------------------------------------
 //category filtration
//    List <Product>  findByCategories (String catName) {
//    List catList = homeModel.data.products.where((element) => element.categoryName.toLowerCase()
//    .contains(catName.toLowerCase()), ).toList();
//    return catList ;
//  }


//-----------------------------------------------------------------------
//image picker لاضافة صوره

File pickedImage;
//pickedImage
final picker = ImagePicker() ;


void  getImage ({ImageSource src , String uploadMainFolderName , String uploadChildFolderName}) async{  
  emit(GetImaeLoadingState());                 // فانكشن نستدعيها ونديها هايفتح الصوره منين... ImageSource.camera , ImageSource.gallary
    await picker.getImage(source:src ).then((value) 
 {
     if (value !=null )
     {
       pickedImage= File(value.path);
        emit(GetImaeSuccessState());
      uploadImagesToFirebaseStorageAndGetLink(image:pickedImage , mainFolderName:uploadMainFolderName ,
       childFolderName: uploadChildFolderName ).
       then((value) {
       print('from home cubit: $imageUrl');
       emit(UploadImagesToFirebaseStorageAndGetLinkSuccessState());
       }).catchError((error)=>print('home cubit firebase Storsge images : ${error.toString()}'),  );
       print(value.path); 
     }     
 }
 ).catchError((error) 
 {
   print(error.toString());
   emit(GetImaeErrorState(error.toString()));
 });          
} 

//for user images mainFolderName = 'userImages'
String imageUrl;
Future<void> uploadImagesToFirebaseStorageAndGetLink(
  {@required String mainFolderName ,@required String childFolderName ,@required File image}) async
{
  emit(UploadImagesToFirebaseStorageAndGetLinkLoadingState());
   final ref = FirebaseStorage.instance.ref(mainFolderName).child(childFolderName+'.jpg');
   await ref.putFile(image); 
   imageUrl= await ref.getDownloadURL();
   print(imageUrl);
   emit(UploadImagesToFirebaseStorageAndGetLinkSuccessState());
}


//multible images-------------------------------------------------------------

List<Asset> assetImages =<Asset>[] ; 
//List<AssetEntity> assetImages =<AssetEntity>[] ; 
List<File> fileImages  =<File>[]; 
List <String> imagesUrl = <String>[];
 // get multiple images-----------------------------
 Future getImagesAssets({@required String childFolderName , @required String mainFolderName , context } ) async {              
        //function
   emit(GetListOFImageLoadingState());
 //  resultList =

  // await AssetPicker.pickAssets(context , maxAssets: 5 ,  ).then((value) async {
  //    assetImages.addAll(value);
  //    await getImageFileFromAssets(assetImages , childFolderName , mainFolderName);
  //    emit(GetImagesAssetsSuccessState());
  //    print(assetImages);
  // }).catchError((error) {
  //     print(error);
  //    emit(GetImagesAssetsErrorState());
  // });

  
  await MultiImagePicker.pickImages(
   maxImages: 5,                          //اقصى عدد صور ممكن يختاره
   selectedAssets: assetImages ,                  // الصوره المختاره هاتحفظها فين
   enableCamera : true ,
  //  materialOptions : MaterialOptions(    
  //    actionBarColor: "blue" ,
  //    selectCircleStrokeColor: 'blue'
  //  ),
   ).then((value)async {
     assetImages.addAll(value)  ;
     emit(GetImagesAssetsSuccessState());
     await getImageFileFromAssets(assetImages , childFolderName , mainFolderName);
     print(assetImages);
   }).catchError((error) {
     print(error);
     emit(GetImagesAssetsErrorState());
   }) ;

 }
// convert AssetImagesList to File ImageList-----------
   //List<AssetEntity>
Future<void> getImageFileFromAssets(List<Asset> assetImages ,  String childFolderName  , String mainFolderName) async {
   
  //  assetImages.forEach((element) { 
  //    AssetEntityImageProvider(element , isOriginal: false).entity.originFile.then((value)async {
  //      fileImages.add(value);
  //      emit(GetImageFileFromAssetsSuccessState());
  //      await uploadListOfImagesToFirebaseStorageAndGetLinks (mainFolderName:mainFolderName ,childFolderName:childFolderName
  //    , fileImages: fileImages);
  //    emit(GetImageFileFromAssetsAgainSuccessState());
  //    }).catchError((error){
  //      print(error);
  //    });
  //  });

      
  
      assetImages.forEach((element)async {
     final byteData = await element.getByteData();
     final tempFile =
        File("${(await getTemporaryDirectory()).path}/${element.name}");
    //  final file =
       await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    ).then((value) async { 
      fileImages.add(value);
     emit(GetImageFileFromAssetsSuccessState());
     // return value;
    }).catchError((error){
      print('dddwefeff : $error');
    });
     });
     await uploadListOfImagesToFirebaseStorageAndGetLinks (mainFolderName:mainFolderName ,childFolderName:childFolderName
     , fileImages: fileImages);
     emit(GetImageFileFromAssetsAgainSuccessState());
    //final byteData = await asset.getByteData();
    
  }

 
//upload list<file>Images to fireStore and get links-------------------
Future<List<String>> uploadListOfImagesToFirebaseStorageAndGetLinks(
  {@required String mainFolderName ,@required String childFolderName ,@required List<File> fileImages}) async
{
  int count = 0;
  emit(UploadListOfImagesToFirebaseStorageAndGetLinkLoadingState());
  fileImages.forEach((element) async {
   final ref =  FirebaseStorage.instance.ref(mainFolderName).child(childFolderName+uuid.v4().toString()+'.jpg');
     await ref.putFile(element); 
    imagesUrl.add(await ref.getDownloadURL());  
    print(imagesUrl); 
    count++ ;
    emit(UploadListOfImagesOneByOneToFirebaseStorageAndGetLinkSuccessState());
    
    if (count >fileImages.length )
    {
      emit(UploadListOfImagesToFirebaseStorageAndGetLinkSuccessState()); 
    assetImages =<Asset>[] ; 
     fileImages  =<File>[]; 
     
    emit(GarpgeState());
  }
  print(count);
  });
      
       assetImages =<Asset>[] ; 
      fileImages  =<File>[]; 
     
    emit(GarpgeState());
   print(imagesUrl);
   return  imagesUrl;
}

 void removeImage() {
 
    pickedImage = null;
    imageUrl = null;
     imagesUrl= <String>[];
  // assetImages =<AssetEntity>[] ; 
assetImages =<Asset>[] ; 
fileImages  =<File>[]; 
//fileImages.removeRange(1, assetImages.length);
 //assetImages.removeRange(1, assetImages.length);
  emit(RemoveAllmagesOFProductSuccessState());
  }

  //-------------------------------------------------------- 
    Map<String, dynamic> tagInfo = {};
   TagModel tagInformation;

   Future<bool> checkNfcTurnOn()async {
  bool supportsNFC ;
     supportsNFC = await NFC.isNDEFSupported;
     return supportsNFC ;
  }


IconData suffixIcon = Icons.visibility_outlined;
bool isPasswordShow = true ;

void changePasswordVisibility ()
{
  isPasswordShow = !isPasswordShow ;
  suffixIcon = isPasswordShow?Icons.visibility_outlined:Icons.visibility_off_outlined ;
  emit(ChangePasswordSignUpVisibilitySuccessState());
}

 
}


