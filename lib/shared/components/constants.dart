
//token: K7FiZsSxAsGKZGjvQmEOqWg1DMxQdgB6cRhJNoqZ7dwxgC9C8pXhRflXn1rJtOFn0ZuigJ
import 'package:flutter/material.dart';
import 'package:zenon/models/categories_model.dart';
import 'package:zenon/shared/network/local/cacheHelper.dart';
String userToken ='';
// 'Fl09gqABQx8KkbQ0IfIAjdEXaOAQBy9aGrdMPpPoH4ESoPbyozSXdtOraGWawZRCR0Fk96';
bool isdarkTheme = false ;
 CategoriesModel categoriesModelConst;
void signOut ({context}) {
    CacheHelper.removeData(key:'token').then((value) {
      if (value) {
        Navigator.of(context)
            .pushReplacementNamed('/loginScreen').catchError((error)
                    {print(error.toString());});
      }
    });
  

}


void printFullText(String text)
{
  final pattern = RegExp('.{1,800}') ;//800 = size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)),);
}