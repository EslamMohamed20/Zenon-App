

class FirebaseProductModel {
    FirebaseProductModel({
        this.tagId,
        this.productId,
        this.firebaseId,
        this.userUploadId,
        this.name,
        this.price,
        this.oldPrice,
        this.quantatity,
        this.image,
        this.prandName, 
        this.description,
        this.images,
        this.inFavorites,
        this.inCart,
        this.categoryName ,
        this.uploadDate ,
        this.createdAt ,
    });

    String firebaseId;
    String productId; // serial num
    String tagId;
    String userUploadId;
    double price;
    double oldPrice;
    String image;
    String name;
    String categoryName;
    String prandName;
    int quantatity;
    String description;
    String uploadDate;
    List<String> images;
    String createdAt ;
    bool inFavorites;
    bool inCart;

    factory FirebaseProductModel.fromJson(Map<String, dynamic> json) => FirebaseProductModel(
        tagId: json["tagId"],
        productId : json["productId"],
        userUploadId : json["userUploadId"],
        firebaseId: json["firebaseId"],
        price: json["price"].toDouble(),
        oldPrice: json["oldPrice"].toDouble()??0.0,
        prandName : json["prandName"],
        categoryName : json["categoryName"],
        image: json["image"],
        name: json["name"],
        description: json["description"],
        uploadDate: json["uploadDate"],
        images: List<String>.from(json["images"].map((x) => x)),
        quantatity: json["quantatity"],
        createdAt : json["createdAt"],
        inFavorites: json["inFavorites"] ??false,
        inCart: json["inCart"]??false,
        

    );

    Map<String, dynamic> toJson() => {
        "tagId": tagId,
        "productId": productId,
        "userUploadId" :userUploadId ,
        "firebaseId" :firebaseId ,
        "price": price,
        "old_price": oldPrice??0.0,
        "prandName" : prandName ,
        "categoryName":categoryName,
        "image": image,
        "name": name,
        "description": description,
        "uploadDate":uploadDate,
        "images": List<dynamic>.from(images.map((x) => x)),
        "quantatity":quantatity ,
        "createdAt":createdAt ,
        "in_favorites": inFavorites??false,
        "in_cart": inCart??false,
    };
}
