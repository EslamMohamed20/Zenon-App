class ByMeCartModel {
  final String tagId;
  final String productFullNameOnTag;
  final String productName;
  final double productPrice;

  final String productid;
  final String firebaseproductid;
  final double productOldPrice;
  final int productquantity;
  final String productImage;

  ByMeCartModel({
    this.tagId,
    this.productName,
    this.productPrice,
    this.productFullNameOnTag,
    this.firebaseproductid,
    this.productImage,
    this.productid,
    this.productOldPrice = 0.0,
    this.productquantity,
  });

  factory ByMeCartModel.fromJson(Map<String, dynamic> json) => ByMeCartModel(
        tagId: json["tagId"],
        productName: json["productName"],
        productPrice: json["productPrice"],
        productFullNameOnTag: json["productFullNameOnTag"],
        productquantity: json["productquantity"] ?? 1,
        firebaseproductid: json["firebaseproductid"] ,
        productImage: json["productImage"] ,
        productid: json["productid"] ,
        productOldPrice: json["productOldPrice"] ?? 0.0,
      );

    Map<String, dynamic> toJson() => {
        "tagId:": tagId,
        'firebaseproductid':firebaseproductid,
        "productName":productName,
        "productPrice": productPrice,
        "productOldPrice": productOldPrice??0.0,
        'productFullNameOnTag':productFullNameOnTag ,
        'productquantity' :productquantity ,
        "productImage": productImage,
        "productid": productid,
    };

}
