class CartModel {
    CartModel({
        this.id,
        this.price,
        this.oldPrice,
        this.image,
        this.name,
        this.quantity,
        this.discount ,
        this.index,
    });

    String id;
    double price;
    double oldPrice =0.0;
    int discount ;
    int index;
    int quantity;
    String image;
    String name;

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        index: json["index"],
        price: json["price"].toDouble(),
        oldPrice: json["old_price"].toDouble()??0.0,
        discount: json["price"],
        image: json["image"],
        name: json["name"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "index":index,
        "price": price,
        "old_price": oldPrice??0.0,
        ' discount':discount ,
        "image": image,
        "name": name,
    };
}
