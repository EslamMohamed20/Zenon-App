
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/models/login_model.dart';
import 'package:zenon/modules/login/login_cubit/zenon_gest_model.dart';
import 'package:zenon/modules/sign_up/sign_up_cubit/sign_up_cubit.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/network/local/cacheHelper.dart';
import 'package:zenon/shared/network/remote/dio_helper.dart';
import 'package:zenon/shared/network/remote/end_points_urls/end_points.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<AppLoginStates>{
LoginCubit():super(AppLoginInitState());  //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
static LoginCubit get(context) => BlocProvider.of(context);  // CounterCubit.get(context).توصل لاى حاجه جوه
//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها

LoginModel loginModel ;


//user login logic withapi----------------
//is token = true if login as agest
Future<void> UserLogin({
  @required String email ,
   @required String password ,
    @required BuildContext context ,
    bool istoken=false ,
}) async {
  if (!istoken){
  emit(AppLoginLoadingState());
  DioHelper.postData(
    posturl:LOGIN,   //login endpoint
     postData:
   {
     'email':email ,
     'password': password,
  }).then((value) 
  async{
    print(value.data);
    loginModel= LoginModel.fromJson(value.data);
    if(loginModel.status)
       {
         CacheHelper.saveData(key: 'token',
               value:loginModel.data.token).then((value){
                 userToken = loginModel.data.token ;   //مهمه جدا تنفذهل هنا + ف دالة المين             
               });
       await fetchDateAfterLogin(context);
    emit(AppLoginSuccesstState(loginModel));
       }
  }).catchError((error)
  {   print(error.toString());
    emit(AppLoginErrorState(error.toString()),);
  });
  }
}


//login with firebase-------------------------
//is token = true if login as agest
final FirebaseAuth _auth = FirebaseAuth.instance ;
 
userLoginWithFirebaseEmail({ @required String email ,
   @required String password ,@required BuildContext context , bool istoken = false}) async
{
   emit(UserLoginWithFirebaseEmailLoadingState());
  await _auth.signInWithEmailAndPassword(email: email.toLowerCase().trim(), password: password.trim()).
  then((value) {
    UserLogin(context: context  , email:email.toLowerCase().trim()  ,password:password.trim(), istoken: istoken) ;
     emit(UserLoginWithFirebaseEmailSuccesstState(value));
      
  }).catchError((error) {  
    emit(UserLoginWithFirebaseEmailErrorState(error));
  });
}
///google login-------------------
  UserCredential googleAuthResult;
userLoginWithFirebaseGoogle({@required BuildContext context}) async
{
  emit(UserLoginWithFirebaseGoogleLoadingState());
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
              phone: value.user.phoneNumber??'${DateTime.now().second}', 
              image:value.user.photoURL , 
              context: context).then((value) async{
                await fetchDateAfterLogin(context);
                emit(UserLoginWithFirebaseGoogleSuccesstState('dd'));
              });
           
           
          }else 
          {
            UserLogin(email: value.user.email, password: value.user.email, context: context).
            then((value) =>  emit(UserLoginWithFirebaseGoogleSuccesstState('ss')),);
           
          }
          
        }).catchError((error){
          print(error);
          emit(UserLoginWithFirebaseGoogleErrorState(error));
        });
    }
  }


}

//facebook login-----------------------

FacebookLogin _faceAuth = FacebookLogin();

userLoginWithFirebaseFacebook ()
async{
  FacebookLoginResult fbResult = await _faceAuth.logIn(['email']);
  final fbAcessToken = fbResult.accessToken.token;

  if(fbResult.status == FacebookLoginStatus.loggedIn)
  {
    final fbCredential = FacebookAuthProvider.credential(fbAcessToken);
    await _auth.signInWithCredential(fbCredential);
  }
}
ZenonGestModel gestInfo ;
//get gestUser email & password-----------------------
Future <void >getGestInfoFromFirebase()async{
emit(GetGestInfoFromFirebaseLoadingState());
await FirebaseFirestore.instance.collection('zenonGest').doc('gest')
.get().then((gest) {
   gestInfo = ZenonGestModel.fromJson(gest.data());
   emit(GetGestInfoFromFirebaseSuccessState());
}).catchError((error){
  emit(GetGestInfoFromFirebaseErrorState());
});

}

//------------------------------
// fetch data after login------------------
Future <void> fetchDateAfterLogin(BuildContext context ){
  emit(FetchDataAfterLoginLoadingState());
  HomeCubit.get(context).getcategoriesData();
  HomeCubit.get(context).getUserData();   
  HomeCubit.get(context).getUserDataFromFirebase();       
  HomeCubit.get(context).getHomeData(); 
  HomeCubit.get(context).getFavoritesData();
  emit(FetchDataAfterLoginSuccessState());
  
}
IconData suffixIcon = Icons.visibility_outlined;
bool isPasswordShow = true ;

void changePasswordVisibility ()
{
  isPasswordShow = !isPasswordShow ;
  suffixIcon = isPasswordShow?Icons.visibility_outlined:Icons.visibility_off_outlined ;
  emit(ChangePasswordVisibilityState());
}

void logOut ({@required context}) async {
  CacheHelper.removeData(key:'token');
  // CacheHelper.saveData(key: 'token', value: 'Fl09gqABQx8KkbQ0IfIAjdEXaOAQBy9aGrdMPpPoH4ESoPbyozSXdtOraGWawZRCR0Fk96');
  //   userToken='Fl09gqABQx8KkbQ0IfIAjdEXaOAQBy9aGrdMPpPoH4ESoPbyozSXdtOraGWawZRCR0Fk96' ;
   // HomeCubit.get(context).navCurrentIndex = 0;
       await _auth.signOut();
    Navigator.of(context)
            .pushReplacementNamed('/loginScreen').catchError((error)
                    {print(error.toString());});
                    print(userToken);
    // CacheHelper.removeData(key:'token').then((value) {
    //   if (value) {
    //      CacheHelper.removeData(key: 'token');
    //       userToken = 'aEwHDpPrximnKIfcfWOODM4fid3nJNrPriF7aqLX1w7diOl7GmzNPHXpbZCcOPOwWtWjnR';
    //     Navigator.of(context)
    //         .pushReplacementNamed('/loginScreen').catchError((error)
    //                 {print(error.toString());});
    //                 print(userToken);
    //   }
    // });
 

}

}