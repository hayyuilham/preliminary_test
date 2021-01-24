import 'dart:convert';

List<ProductResponse> productResponseFromJson(String str) =>
    List<ProductResponse>.from(
        json.decode(str).map((x) => ProductResponse.fromJson(x)));

String productResponseToJson(List<ProductResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductResponse {
  ProductResponse(
      {this.id,
      this.name,
      this.imageUrl,
      this.brandName,
      this.packageName,
      this.price,
      this.rating,
      this.qty});

  int id;
  String name;
  String imageUrl;
  String brandName;
  String packageName;
  int price;
  double rating;
  int qty;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
          id: json["id"],
          name: json["name"],
          imageUrl: json["image_url"],
          brandName: json["brand_name"],
          packageName: json["package_name"],
          price: json["price"],
          rating: json["rating"].toDouble(),
          qty: json["qty"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
        "brand_name": brandName,
        "package_name": packageName,
        "price": price,
        "rating": rating,
        "qty": qty
      };
}
