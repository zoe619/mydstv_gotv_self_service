
class Bouquet{
  String id;
  String brand;
  String bouquet;
  String price;

  Bouquet({this.id, this.brand, this.bouquet, this.price});

  factory Bouquet.fromJson(Map<String, dynamic> json)
  {
    return Bouquet(
        id: json['id'] as String,
        brand: json['brand'] as String,
        bouquet: json['bouquet'] as String,
        price: json['price'] as String

    );
  }
}