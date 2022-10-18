class CartModel{
  String? pid;
  String? uid;
  String? name;
  String? imageUrl;
  int price;
  int qty;

  CartModel({this.pid, this.uid, this.name, this.imageUrl, this.price = 0, this.qty = 0});

  factory CartModel.fromMap(map){
    return CartModel(
      pid: map['pid'],
      uid: map['uid'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      qty: map['qty']
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'pid': pid,
      'uid': uid,
      'name':name,
      'imageUrl': imageUrl,
      'price':price,
      'qty':qty
    };
  }
}