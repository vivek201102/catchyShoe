class ProductModel{
  String? pid;
  String? name;
  int? price;
  String? category;
  String? imageUrl;
  String? des;
  int? qty;

  ProductModel({this.qty,this.pid,this.name,this.price,this.category,this.des,this.imageUrl});

  //receive
  factory ProductModel.fromMap(map){
    return ProductModel(
      pid: map['pid'],
      name: map['name'],
      des: map['des'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      qty: map['quantity']
    );
  }

  //send
  Map<String, dynamic> toMap(){
    return {
      'pid': pid,
      'name': name,
      'des': des,
      'category': category,
      'imageUrl':imageUrl,
      'price': price,
      'quantity':qty,

    };
  }
}


