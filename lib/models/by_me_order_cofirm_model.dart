


class BymeOrderConfirmModel{
 final String cardId;
 final bool orderDone;
 final String orderNumber;
final double totalAmount;  //قيمة الفلوسال ع الكارت

  BymeOrderConfirmModel({
    this.cardId, 
   this.orderDone,
   this.orderNumber,
   this.totalAmount,
  });
  
     factory BymeOrderConfirmModel.fromJson(Map<String, dynamic> json) => BymeOrderConfirmModel(
        cardId: json["cardId"],
        orderDone: json["orderDone"]??false,
        totalAmount: json["totalAmount"].toDouble()??0.0,
        orderNumber: json["orderNumber"],
    );


}


