
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import '../styles/colors.dart';

ThemeData lightTheme =  ThemeData(
        primarySwatch: defaultColor,
        backgroundColor: Colors.white ,
        scaffoldBackgroundColor: Color(0xFFE0E0E0) ,
        fontFamily: 'Raleway',
        appBarTheme: AppBarTheme(
          titleSpacing:0 ,
          elevation: 4,
          shadowColor: Colors.black26,
          color: Colors.white ,
          titleTextStyle: TextStyle(color:HexColor('333739'),
             fontSize: 26, fontWeight: FontWeight.w900 ,letterSpacing: 1,
             fontFamily: 'PlayfairDisplay' ,
             ),
          actionsIconTheme:IconThemeData(color: Colors.black ,),
          iconTheme: IconThemeData(color: Colors.black , ),

          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white ,
            statusBarIconBrightness: Brightness.dark ,
          ),
          ),
         textTheme: TextTheme(
           bodyText1: TextStyle(
             fontSize: 18 , 
             fontWeight: FontWeight.w600,
             color: Colors.black ,
           ),
           headline5: TextStyle(
             fontSize: 26 ,
             fontWeight: FontWeight.w700,
             color: Colors.black ,
             fontFamily: 'PlayfairDisplay' ,
           ),
         ),
         bottomNavigationBarTheme: 
         BottomNavigationBarThemeData(
           type: BottomNavigationBarType.fixed,
           selectedItemColor: defaultColor ,
           unselectedItemColor: Colors.grey,
           elevation: 20.0 ,
           backgroundColor: Colors.white,
           selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
           selectedIconTheme: IconThemeData(size: 26.0, ),
           
           )
      );


ThemeData darkTheme = ThemeData(
        scaffoldBackgroundColor:HexColor('333739'),
        //Colors.grey.shade800,
        //HexColor('333739'),
         primarySwatch: defaultColor,
        backgroundColor: Colors.white ,
        //HexColor('333739'),
       // Colors.grey.shade800,
        //HexColor('333739'),
        fontFamily: 'Raleway',
        appBarTheme: AppBarTheme(
           titleSpacing:0 ,
          elevation: 2,
          shadowColor: Colors.white30,
          color: defaultColor,
          //HexColor('333739')  ,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: defaultColor ,
               // HexColor('333739') ,
            statusBarIconBrightness: Brightness.light
          ),
          titleTextStyle: TextStyle(color: Colors.grey[200] ,
          //Colors.white,
             fontSize: 26, fontWeight: FontWeight.w900 ,letterSpacing: 1,
             fontFamily: 'PlayfairDisplay' ,
             ),
          actionsIconTheme:IconThemeData(color: Colors.grey[200] ,
          //Colors.white ,
            ) ,
          ),
         textTheme: TextTheme(
           bodyText1: TextStyle(
             fontSize: 18 , 
             fontWeight: FontWeight.w600,
             color: Colors.white ,
           ),
           headline5: TextStyle(
              fontSize: 26 ,
             fontWeight: FontWeight.w700,
             color: Colors.white ,
             fontFamily: 'PlayfairDisplay' ,

           ),
         ),
         bottomNavigationBarTheme: 
         BottomNavigationBarThemeData(
           type: BottomNavigationBarType.fixed,
           selectedItemColor: defaultColor ,
           unselectedItemColor: Colors.grey[350],
           elevation: 20.0 ,
           backgroundColor: Colors.grey.shade800 ,
           //HexColor('333739'),
           selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
           selectedIconTheme: IconThemeData(size: 26.0, ),
           
           )
      );
