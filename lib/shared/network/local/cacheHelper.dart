
//shared prefs
//كلاس بناديه واكسس عليه

//in main.dart
//  await CacheHelper.init();

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
  
class CacheHelper {
 
   static SharedPreferences sharedPref ;

  static init() async{  // بتناديها الاول جوه ال void main
     sharedPref = await SharedPreferences.getInstance();
  }
 
//  static bool getData ({@required String key}){
//   return  sharedPref.getBool(key);
//  }
// 
  
  //set anytype of data
  static Future<bool> saveData (
    {@required String key,
    @required dynamic value ,}
  )async {
   
  if(value is String) return await sharedPref.setString(key, value);
  if(value is int) return await sharedPref.setInt(key, value);
  if(value is bool) return await sharedPref.setBool(key, value);
  
  return await sharedPref.setDouble(key, value);
  }
  
  //get any type of data
  static dynamic  getData ({@required String key}){
  return  sharedPref.get(key);
 }
  
  //remove data from specific key
  static Future<bool> removeData({@required String key}) async
  {
    return await sharedPref.remove(key);
  }
  
}