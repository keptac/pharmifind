class Drug {
  String id;
  String name;
  String drugPrice;
  String pharmacy;

  Drug({this.id, this.name, this.drugPrice, this.pharmacy});

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      id: json['id'] as String,
      name: json['name'] as String,
      drugPrice: json['drugPrice'] as String,
      pharmacy: json['pharmacy'] as String,
    );
  }
}
