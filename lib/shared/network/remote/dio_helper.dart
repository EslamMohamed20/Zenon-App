

//baseurl: https://student.valuxapps.com/api/

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static Dio dio;

  static init({@required String baseUrl}) {
    dio = Dio(
      BaseOptions(baseUrl: baseUrl,
       receiveDataWhenStatusError: true, 
       ),
    );
  }

  // get data function
  static Future<Response> getData({
    @required String url,
    Map<String, dynamic> query,
    String lang = 'en',
    String token,
  }) async {
     dio.options.headers ={
         'Content-Type' : 'application/json' ,
         'lang' : lang,
         'Authorization': token??'' ,
      };
    return await dio.get(
      url,
      queryParameters: query??null,
    );
  }
 

 //post data function
  static Future<Response> postData({
    @required String posturl,
    Map<String, dynamic> postquery,
    @required Map<String, dynamic> postData,
    String lang = 'en',
    String token,
  }) async {
    dio.options.headers ={
         'Content-Type' : 'application/json' ,
         'lang' : lang,
         'Authorization': token??'' ,
      };
    return await dio.post(
      posturl,
      queryParameters: postquery,
      data: postData,
    );
  }

//Put data function ...update
 static Future<Response> putData({
    @required String puturl,
    Map<String, dynamic> putquery,
    @required Map<String, dynamic> putData,
    String lang = 'en',
    String token,
  }) async {
    dio.options.headers ={
         'Content-Type' : 'application/json' ,
         'lang' : lang,
         'Authorization': token??'' ,
      };
    return await dio.put(
      puturl,
      queryParameters: putquery,
      data: putData,
    );
  }



}
