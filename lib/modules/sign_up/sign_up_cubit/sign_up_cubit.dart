
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/models/login_model.dart';
import 'package:zenon/modules/login/login_cubit/login_cubit.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/network/local/cacheHelper.dart';
import 'package:zenon/shared/network/remote/dio_helper.dart';
import 'package:zenon/shared/network/remote/end_points_urls/end_points.dart';

import 'sign_up_states.dart';

class SignUpCubit extends Cubit<AppSignUpStates>{
SignUpCubit():super(AppSignUpInitState());  //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
static SignUpCubit get(context) => BlocProvider.of(context);  // CounterCubit.get(context).توصل لاى حاجه جوه
//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها

LoginModel signUpModel ;

//api--------------
//user SignUp logic with api ---------------------------------------------------
Future<void> userSignUpData({
  @required String email ,
   @required String password ,
    @required String name ,
     @required String phone ,
     @required String image ,
     @required BuildContext context ,


}){
  emit(AppSignUpLoadingState());
  print('from signup method : $image');
  DioHelper.postData(
    posturl:REGISTER,   //SignUp endpoint
     postData:
   {
     'name':name ,
     'phone':phone ,
     'email':email ,
     'password': password,
      'image' :image,
  }).then((value) 
  {
    print(value.data);
    signUpModel= LoginModel.fromJson(value.data);
    if (signUpModel.status) {
    CacheHelper.saveData(key: 'token',
                 value:signUpModel.data.token).then((value){
                 userToken = signUpModel.data.token ;});
      userSignUpWithFirebaseEmail(context:context , email:email 
      ,password:password  ,name:name , image: image, phone: phone,);
      // HomeCubit.get(context).getUserData();          
      // HomeCubit.get(context).getHomeData();
      // HomeCubit.get(context).getFavoritesData();
      // HomeCubit.get(context).getcategoriesData();  
   emit(AppSignUpSuccesstState(signUpModel));
    }
    emit(AppSignUpErrorState(value.data['message'].toString()),);
  }).catchError((error)
  {   print(error.toString());
    emit(AppSignUpErrorState(error.toString()),);
  });
}
//----------------------------------------------------------------------------

//firebase........................
final FirebaseAuth _auth = FirebaseAuth.instance ;

userSignUpWithFirebaseEmail({ @required String email ,
   @required String password ,@required BuildContext context ,
     @required String name ,
     @required String phone ,
     @required String image ,
    }) async
{
  await _auth.createUserWithEmailAndPassword(email: email.toLowerCase().trim(),
       password: password.trim()).
  then((value) async {
   await uploadUserInfoOnFireStoreSignUp(name:name ,phoneNumber: phone ,
    email: email ,imageUrl: image ,  );
     emit(UserSignUpWithFirebaseEmailSuccesstState(value));
      
  }).catchError((error) {  
    emit(UserSignUpWithFirebaseEmailErrortState(error));
  });
}

  
  UserCredential googleAuthResult;

userSignUpWithFirebaseGoogle({@required BuildContext context}) async
{
 
  final googleSignIn = GoogleSignIn();
  final googleAccount = await googleSignIn.signIn();
  if(googleAccount != null)
  {
    //to get google credential:
    final googleAuth = await googleAccount.authentication;
    if(googleAuth.accessToken != null && googleAuth.idToken != null)
    {
      //now we can allow the user to signIn:
       googleAuthResult = await  _auth.signInWithCredential(
          GoogleAuthProvider.credential(accessToken: googleAuth.accessToken , 
          idToken: googleAuth.idToken
           )
        ).then((value) {
          print(value);
          if(value.additionalUserInfo.isNewUser)
          {
            SignUpCubit.get(context).userSignUpData(email: value.user.email,
             password: value.user.email,
             name: value.user.displayName,
              phone: value.user.phoneNumber??'UnKnown', 
              image:value.user.photoURL , 
              context: context).then((value) => emit(UserSignUpWithFirebaseGoogleSuccesstState('dd')),);
            
          }else 
          {
            LoginCubit.get(context).UserLogin(email: value.user.email, password: value.user.email, context: context).
            then((value) =>  emit(UserSignUpWithFirebaseGoogleSuccesstState('ss')),);
           
          }
          
        }).catchError((error){
          emit(UserSignUpWithFirebaseGoogleErrorState(error));
        });
    }
  }


}


//save more user info in firestore
Future <void> uploadUserInfoOnFireStoreSignUp({
@required String name ,
@required String email ,
@required String phoneNumber ,
String zenonCardId ,
 String creditCardID,
@required String imageUrl , 
String adress_1,
String adress_2,
}) async
{
  var date = DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
  final User user = _auth.currentUser;
  final _uid  = user.uid;
  await FirebaseFirestore.instance.collection('users').doc(_uid ).
  set({
   'id':_uid ,
    'name':name ??"please login" ,
    'email':email ??"please login",
    'phoneNumber': phoneNumber??'please enter ypur phone' , 
    'imageUrl' : imageUrl??'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avtar-photo-placeholder-profile-image-vector-21666260.jpg',
    'joinedAt':formattedDate ,
    'createdAt':Timestamp.now(),
    'zenonCardId': zenonCardId??'Unknown',
    'creditCardID':creditCardID??'Unknown',
    'adress1':adress_1 ??'enter your adress' ,
    'adress2':adress_2 ??'unknwon',

  });
}

//تغير ايكونة العين
IconData suffixIcon = Icons.visibility_outlined;
bool isPasswordShow = true ;

void changePasswordVisibility ()
{
  isPasswordShow = !isPasswordShow ;
  suffixIcon = isPasswordShow?Icons.visibility_outlined:Icons.visibility_off_outlined ;
  emit(ChangePasswordSignUpVisibilityState());
}

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
        emit(GetImaeSuccesstState());
      uploadImagesToFirebaseStorageAndGetLink(image:pickedImage , mainFolderName:uploadMainFolderName ,
       childFolderName: uploadChildFolderName ).
       then((value) {
       print('sssss: $imageUrl');
       emit(UploadImagesToFirebaseStorageAndGetLink());
       }).catchError((error)=>print('firebase Storsge images : ${error.toString()}'),  );
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
   final ref = FirebaseStorage.instance.ref(mainFolderName).child(childFolderName +'.jpg');

   await ref.putFile(image); 
   imageUrl= await ref.getDownloadURL();
   print(imageUrl);
   emit(UploadImagesToFirebaseStorageAndGetLink2());
}



}