import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/modules/login/login_cubit/login_states.dart';
import 'package:zenon/modules/settings/settings_screen.dart';
import 'package:zenon/user_state.dart';
import './modules/on_boarding/on_boarding_screen.dart';
import 'layout/home_cubit/home_cubit.dart';
import 'layout/upload_product_form.dart';
import 'layout/zenon_layout.dart';
import 'main_screen.dart';
import 'modules/Cart/cart_screen.dart';
import 'modules/by_me_user/by_me_cubit/by_me_cubit.dart';
import 'modules/by_me_user/by_me_screen.dart';
import 'modules/catigories/categories_screen.dart';
import 'modules/catigories/inner_screens/brands_navigation_rail_screen.dart';
import 'modules/catigories/inner_screens/category_feed_screen.dart';
import 'modules/favourites/favourites_screen.dart';
import 'modules/login/login_cubit/login_cubit.dart';
import 'modules/login/login_screen.dart';
import 'modules/products/product_details.dart';
import 'modules/products/products_screen.dart';
import 'modules/search/search_screen.dart';
import 'modules/sign_up/sign_up_cubit/sign_up_cubit.dart';
import 'modules/sign_up/sign_up_cubit/sign_up_states.dart';
import 'modules/sign_up/sign_up_screen.dart';
import 'shared/components/constants.dart';
import 'shared/cubit_observe/observe.dart';
import 'shared/network/local/cacheHelper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  DioHelper.init(baseUrl:'https://student.valuxapps.com/api/');
  bool finishOnBoarding = CacheHelper.getData(key: 'onBoarding');
  userToken = CacheHelper.getData(key: 'token');

  //userToken = CacheHelper.getData(key: 'token');  //متعرف الثوابت constant
 // print(userToken.toString());
  String intialAppPageRoute;

  if (finishOnBoarding != null) {  
      intialAppPageRoute = '/MainScreen';
  } else
    intialAppPageRoute = '/onBoardingScreen';


 
 
  

  runApp(
    MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (context) => HomeCubit()..getHomeData()..getProductDataFromFirebase()..getcategoriesData()..getFavoritesData() ..getUserData()..getUserDataFromFirebase()..getDarkTheme(),
              //..themeChange(isDark),

             
            ),
            BlocProvider<CartCubit>(create: (context) =>CartCubit()),
            BlocProvider<LoginCubit>(create: (context) =>LoginCubit()..getGestInfoFromFirebase() ),
            BlocProvider<SignUpCubit>(create: (context) =>SignUpCubit() ),
             BlocProvider<ByMeCubit>(create: (context) => ByMeCubit()..checkNfcTurnOn()..getProductDataFromFirebaseandFiltered(),),
          ],
          child: 
          //BlocConsumer<HomeCubit ,HomeStates>(
          //   listener: (context , state){},
          //   builder:(context , state){
            //  return 
                MyApp(
                 intialAppPageRoute: intialAppPageRoute,
                // themeCubit:  themeCubit ,
               ),
         
          //  } ,
                     ),

    //  ),
      );
 
      
}

class MyApp extends StatelessWidget {
  final String intialAppPageRoute;
 // final bool themeCubit ;

  MyApp({this.intialAppPageRoute ,});
 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zenon App',
      theme: lightTheme ,
      themeMode: !isdarkTheme? ThemeMode.light : ThemeMode.dark,
      // AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light ,
      darkTheme: darkTheme,
      //home: OnBoardingScreen(),

      initialRoute: intialAppPageRoute,
      routes: {
        '/MainScreen': (context) => MainScreen(),
        '/UserStateScreen' :(context) => UserState(),
        '/HomePage': (context) => HomePage(),
        '/onBoardingScreen': (context) => OnBoardingScreen(),
        '/loginScreen': (context) => LoginScreen(),
        '/signUpScreen': (context) => SignUpScreeen(),
        '/productsScreen': (context) => ProductsScreen(),
        '/ProductDetailsScreen' : (context) => ProductDetails(),
        '/categoriesScreen': (context) => CategoriesScreen(),
        '/favouritesScreen': (context) => FavouritesScreen(),
        '/searchScreen': (context) => SearchScreen(),
        '/settingScreen': (context) => SettingScreen(),
        '/byMeScreen' : (context) => ByMeScreen(),
         '/cartScreen': (context) =>CartScreen() ,
         '/Categouries_navigation_rail' : (context) =>CategouriesNavigationRailScreen(),
         '/UploadProductFormScreen' : (context) =>  UploadProductForm(),
       //  '/CategoryFeedsScreen' : (context)  =>CategoryFeedsScreen(),
      },
      //LoginScreen(),
      //MyHomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {

//     // var cubit =AppCubit.get(context);
//    // print('build : ${cubit.teslaData.length}');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Zenon'),
//        // backgroundColor: Colors.white,
//         // actions:[
//         //   IconButton(
//         //     icon: Icon(Icons.search),
//         //     onPressed: () {
//         //      navigatorPush(context , SearchScreen());
//         //      } ,
//         //   ),
//         //   IconButton(
//         //     icon: Icon(Icons.brightness_4_outlined),
//         //     onPressed: () {
//         //     cubit.themeModeChange();
//         //     } ,
//         //   ),
//         // ],
//       ),
//       body:null ,

//     );
//   }
// }
