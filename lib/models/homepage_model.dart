// To parse this JSON data, do
//
//     final homePageProducts = homePageProductsFromJson(jsonString);

import 'dart:convert';

List<HomePageProducts> homePageProductsFromJson(String str) => List<HomePageProducts>.from(json.decode(str).map((x) => HomePageProducts.fromJson(x)));

String homePageProductsToJson(List<HomePageProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomePageProducts {
  String id;
  List<Product> products;

  HomePageProducts({
    required this.id,
    required this.products,
  });

  factory HomePageProducts.fromJson(Map<String, dynamic> json) => HomePageProducts(
    id: json["_id"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  String id;
  String vendorId;
  String name;
  String displayImage;
  int averageRating;
  String availability;
  String productType;
  String category;
  String? subCategory;
  List<Variant> variant;
  int discount;

  Product({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.displayImage,
    required this.averageRating,
    required this.availability,
    required this.productType,
    required this.category,
    this.subCategory,
    required this.variant,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    vendorId: json["vendorId"],
    name: json["name"],
    displayImage: json["displayImage"],
    averageRating: json["averageRating"],
    availability: json["availability"],
    productType: json["productType"],
    category: json["category"],
    subCategory: json["subCategory"],
    variant: List<Variant>.from(json["variant"].map((x) => Variant.fromJson(x))),
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "vendorId": vendorId,
    "name": name,
    "displayImage": displayImage,
    "averageRating": averageRating,
    "availability": availability,
    "productType": productType,
    "category": category,
    "subCategory": subCategory,
    "variant": List<dynamic>.from(variant.map((x) => x.toJson())),
    "discount": discount,
  };
}

class Variant {
  String? variant1;
  String? variant2;
  String? variantName1;
  String? variantName2;
  String variantName3;
  int listingPrice;
  int sellingPrice;
  int quantity;
  String id;
  int discount;

  Variant({
    required this.variant1,
    required this.variant2,
    required this.variantName1,
    required this.variantName2,
    required this.variantName3,
    required this.listingPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.id,
    required this.discount,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    variant1: json["variant1"],
    variant2: json["variant2"],
    variantName1: json["variantName1"],
    variantName2: json["variantName2"],
    variantName3: json["variantName3"],
    listingPrice: json["listingPrice"],
    sellingPrice: json["sellingPrice"],
    quantity: json["quantity"],
    id: json["_id"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "variant1": variant1,
    "variant2": variant2,
    "variantName1": variantName1,
    "variantName2": variantName2,
    "variantName3": variantName3,
    "listingPrice": listingPrice,
    "sellingPrice": sellingPrice,
    "quantity": quantity,
    "_id": id,
    "discount": discount,
  };
}
