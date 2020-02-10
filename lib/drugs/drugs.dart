class Drug {
  String id;
  String name;
  String price;
  String pharmacy;

  Drug({this.id, this.name, this.price, this.pharmacy});

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as String,
      pharmacy: json['pharmacy'] as String,
    );
  }
}
