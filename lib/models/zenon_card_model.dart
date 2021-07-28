
class ZenonCardModel{
 final String cardId;
 final String userName;
 final String userPhone;
final double cashAmount;  //قيمة الفلوسال ع الكارت

  ZenonCardModel({
    this.cardId, 
    this.userName='',
     this.userPhone='',
      this.cashAmount,
  });
  
     factory ZenonCardModel.fromJson(Map<String, dynamic> json) => ZenonCardModel(
        cardId: json["cardId"],
        userName: json["userName"]??'',
        cashAmount: json["cashAmount"].toDouble()??0.0,
        userPhone: json["userPhone"]??'',
    );


}


