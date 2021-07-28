

class ZenonGestModel{
   String email ;
   String password ;

  ZenonGestModel({this.email, 
  this.password});

  ZenonGestModel.fromJson(Map<String, dynamic> jsonData) {

    email = jsonData['email']; 
    password = jsonData['password']; 

   
   
  }


}