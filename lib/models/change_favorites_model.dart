
class ChangeFavouritesModel 
{
  bool stutus ;
  String message ;
  ChangeFavouritesModel.fromjson(Map<String , dynamic>json)
  {
    stutus= json['status'];
    message = json['message'];
  }
}
