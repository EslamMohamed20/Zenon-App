import 'package:badges/badges.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/styles/colors.dart';
import 'home_cubit/home_cubit.dart';
import 'home_cubit/home_states.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool dataRedy = false ;

   
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
          
        HomeCubit.get(context).getcategoriesData();
     HomeCubit.get(context).getUserData();    
    HomeCubit.get(context).getUserDataFromFirebase();
     HomeCubit.get(context).getHomeData();
    HomeCubit.get(context).getFavoritesData();
        });

        } 
    else if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          isWifiOrMobileData = false;
          isNotConnected = true;

        });
   
    }
  }
  
  whichWidgetThatsWillBeView({HomeCubit homeCubit} ){
    if (isWifiOrMobileData )
    {   if (dataRedy){
      return  homeCubit.bottomNavBarScreens[homeCubit.navCurrentIndex] ;
       } else {
         return  Center(child: CircularProgressIndicator(),);
       }
        
                  
    }else if (isNotConnected){
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
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context )=> HomePage() ));
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
      print(dataRedy);

    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) 
        {
          if(state is FavoritesGetdataSuccessStates)
            {
              setState(() {
                dataRedy = true ;
              });
            }
        },
        builder: (context, state) {
          var homeCubit = HomeCubit.get(context);
          return Scaffold(
            //ارقام الاسكرينات ف اللسته الموجوده ف
            //home cubit
            //علشان البار يظهرش ف صفحات معينه
            appBar: (homeCubit.navCurrentIndex == 4 ||
                    homeCubit.navCurrentIndex == 3)
                ? null
                : AppBar(
                    title: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        //zenon logo
                        Container(
                            width: 45,
                            height: 45,
                            padding: EdgeInsets.only(right: 4.5),
                            alignment: Alignment.bottomCenter,
                            child: Image(
                              image:
                              //homeCubit.isDark
                              isdarkTheme ?AssetImage(
                                'assets/images/zenonLogo5.png',
                              )  :
                              AssetImage(
                                'assets/images/zenonLogo4.png',
                              ),
                              //  fit: BoxFit.cover,
                            )),
                        Text('Zenon'),
                        //search bar
                        Expanded(
                          child: InkWell(
                            radius: 15.0,
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.indigo[200],
                            hoverColor: Colors.indigo[200],
                            highlightColor: Colors.indigo[50],
                            onTap: () {
                              Navigator.of(context).pushNamed('/searchScreen');
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: [
                                Container(
                                  //  width: double.infinity,

                                  height: 30,
                                  padding: EdgeInsets.only(left: 4.5, right: 0),
                                  margin: EdgeInsets.only(left: 4.5, right: 0),

                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                     // homeCubit.isDark
                                      isdarkTheme? Colors.grey[300]: Colors.grey[500],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'What are you looking for?',
                                    style: Theme.of(context)
                                        .appBarTheme
                                        .titleTextStyle
                                        .copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color:
                                           // homeCubit.isDark
                                            isdarkTheme  ? Colors.white: Colors.indigo[300]),
                                    textScaleFactor: 0.89,
                                  ),
                                  //  fit: BoxFit.cover,
                                ),
                                //  Spacer(),
                                Icon(
                                  Icons.search,
                                  color:
                                 // homeCubit.isDark
                                  isdarkTheme ? Colors.white: Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      //cart icon
                      Padding(
                        padding: EdgeInsets.only(left: 4, right: 9),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/cartScreen');
                          },
                          child: Badge(
                             badgeColor:defaultColor,
                position: BadgePosition.topEnd(top: -3 , end: -3.5 ),
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                alignment: Alignment.center,
                elevation: 3,
                

              badgeContent: Text(CartCubit.get(context).cartItems.length.toString() , 
              style: TextStyle(color: Colors.white),),
                                                      child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(

                                   Icons.shopping_cart_outlined,
                                    color: Theme.of(context).appBarTheme.actionsIconTheme.color,
                                    //HexColor('333739'),
                                    size: 27,
                                  ),
                                Text(
                                  'Cart',
                                  textScaleFactor: 0.98,
                                  style: Theme.of(context)
                                      .appBarTheme
                                      .titleTextStyle
                                      .copyWith(
                                        fontSize: 17,
                                        height: 0.75,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).appBarTheme.actionsIconTheme.color,
                                        fontFamily: 'PlayfairDisplay',
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //  IconButton(
                      //     icon:  Icon(Icons.shopping_cart_outlined , color: HexColor('333739'),),
                      //     padding:EdgeInsets.only(left: 0 , right: 8.0 ,top: 8.0 , bottom: 8.0),
                      //     iconSize: 27,
                      //     onPressed: () =>
                      //         Navigator.of(context).pushNamed('/cartScreen'),
                      //   ),
                    ],
                  ),
            body: RefreshIndicator( onRefresh:()=> checkInternetConictivity() ,
              child: whichWidgetThatsWillBeView(homeCubit:homeCubit ) ??Center(child: CircularProgressIndicator(),) ),


            bottomNavigationBar: BottomNavigationBar(
              
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Entypo.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Entypo.layers,
                    ),
                    label: 'Categories'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Feather.heart,
                    ),
                    label: 'Favorites'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.camera_front_outlined,
                    ),
                    label: 'By Me'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Feather.user,
                    ),
                    label: 'Account'),
              ],
              currentIndex: homeCubit.navCurrentIndex,
              onTap: (index) {
                homeCubit.changeBottomNavSreens(index);
              },
            ),
          );
        });
  }
}
