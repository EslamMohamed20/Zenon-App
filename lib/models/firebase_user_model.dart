class FirebaseUserData {
  String firebaseUserID ;
  String name;
  String email;
  String phone;
  String image;
  String adress_1;
  String adress_2;
  String zenonCardId;
  String creditCardID;
  String joinedAt;
  

  FirebaseUserData({

    this.name,
    this.email,
    this.phone,
    this.image,
    this.zenonCardId,
    this.creditCardID,
    this.adress_1,
    this.adress_2,
    this.firebaseUserID ,
    this.joinedAt,
  });

//named Vonstractor

  FirebaseUserData.fromJson(Map<String, dynamic> jsonData) {

    firebaseUserID = jsonData['firebaseUserID']??""; 
    name = jsonData['name']??"";
    email = jsonData['email']??"";
    phone = jsonData['phoneNumber']??"";
    image = jsonData['imageUrl']??"";
    zenonCardId = jsonData['zenonCardId']??"";
    creditCardID = jsonData['creditCardID']??""; 
    adress_1= jsonData['adress1']??"";
   adress_2= jsonData['adress2']??""; 
   joinedAt = jsonData['joinedAt']??"";
   
  }


   Map<String, dynamic> toJson() => {
        "name": name,
        "email":email,
        "phoneNumber":phone,
        "imageUrl":image,
        "firebaseUserID":firebaseUserID,
        "zenonCardId":zenonCardId??"",
        "creditCardID":creditCardID??"",
        "adress1":adress_1??"",
        "adress2":adress_2??"",
        "joinedAt":joinedAt??"",
    };
}
