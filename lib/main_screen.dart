
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/user_state.dart';

import 'layout/home_cubit/home_cubit.dart';
import 'layout/home_cubit/home_states.dart';
import 'layout/zenon_layout.dart';
import 'modules/cart/cubit/cart_cubit.dart';
import 'modules/login/login_cubit/login_cubit.dart';
import 'modules/login/login_cubit/login_states.dart';
import 'modules/login/login_screen.dart';
import 'modules/sign_up/sign_up_cubit/sign_up_cubit.dart';
import 'modules/sign_up/sign_up_cubit/sign_up_states.dart';
import 'shared/network/local/cacheHelper.dart';
//import 'package:connectivity/connectivity.dart';

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  
  String intialAppPageRoute;

   bool isWifiOrMobileData = false ;

 bool isNotConnected = false;

  @override
  initState(){
    checkInternetConictivity();
    super.initState();
  }
  
  Future <void> checkInternetConictivity() async {
     var connectivityResult = await (Connectivity().checkConnectivity());
     if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network || wifi.
        setState(() {
          isWifiOrMobileData=true ; 
          isNotConnected = false;
        });

        } 
    else if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          isWifiOrMobileData = false;
          isNotConnected = true;

        });
   
    }
  }

Widget startScreen () 
  { 
    if (isWifiOrMobileData){
      //&& userToken !='Fl09gqABQx8KkbQ0IfIAjdEXaOAQBy9aGrdMPpPoH4ESoPbyozSXdtOraGWawZRCR0Fk96'
    if (userToken != null) {
      setState(() {
        intialAppPageRoute = '/UserStateScreen';
        
        HomeCubit.get(context).getcategoriesData();
     HomeCubit.get(context).getUserData();    
    HomeCubit.get(context).getUserDataFromFirebase();
     HomeCubit.get(context).getHomeData();
    HomeCubit.get(context).getFavoritesData();
      });
      return UserState();
      
    } else{
         setState(() {
           intialAppPageRoute = '/loginScreen';
         });
       return  LoginScreen();
      
    }
      

  }else if (isNotConnected)
  {
      return  Scaffold(
                      body: Center(
             child:Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children :[
         Image(image: AssetImage('assets/images/internetError.png'),),
         Text('Please,Check your connection' , style: TextStyle(color: Colors.red ,
         fontSize: 18,
          fontWeight: FontWeight.w600),), 
         SizedBox(height: 15,),
        ElevatedButton.icon(
          onPressed: ()async {
           // await checkInternetConictivity();
           // Navigator.of(context).pop();
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context )=> MainScreen() ));
          },

           icon: Icon(Icons.refresh),
            label: Text('Refresh' , style: TextStyle( fontWeight: FontWeight.w500),))


         ]
             ) ,
           
         
         ),
      );
  }


  }
    


  @override
  Widget build(BuildContext context) {
  userToken = CacheHelper.getData(key: 'token');  //متعرف الثوابت constant
  print(userToken.toString());
 
   
    return   MultiBlocListener(
            listeners: [
              BlocListener<HomeCubit , HomeStates> (listener: (context,state){}),
              BlocListener<LoginCubit , AppLoginStates> (listener: (context,state){}),
              BlocListener<SignUpCubit , AppSignUpStates> (listener: (context,state){}),
            ],
             child: Scaffold(
                            body: RefreshIndicator( 
                   onRefresh:()=> checkInternetConictivity() , displacement: 0,strokeWidth: 0,color: Colors.white.withOpacity(0.0),
                   backgroundColor: Colors.white,
                   child: startScreen()??Center(child: CircularProgressIndicator(),) ,),
             ),
             
             
             
            //   startScreen() == '/UserStateScreen'?UserState() 
            //  : LoginScreen(),
             
             )
   
    ;
          
    
  }
}