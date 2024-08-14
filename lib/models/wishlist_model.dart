// To parse this JSON data, do
//
//     final WishlistItemModel = WishlistItemModelFromJson(jsonString);

import 'dart:convert';

List<WishlistItemModel> WishlistItemModelFromJson(String str) => List<WishlistItemModel>.from(json.decode(str).map((x) => WishlistItemModel.fromJson(x)));

String WishlistItemModelToJson(List<WishlistItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishlistItemModel {
  String id;
  String name;
  List<Variant> variant;
  int quantitySold;
  String availability;
  String displayImage;

  WishlistItemModel({
    required this.id,
    required this.name,
    required this.variant,
    required this.quantitySold,
    required this.availability,
    required this.displayImage,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) => WishlistItemModel(
    id: json["_id"],
    name: json["name"],
    variant: List<Variant>.from(json["variant"].map((x) => Variant.fromJson(x))),
    quantitySold: json["quantitySold"],
    availability: json["availability"],
    displayImage: json["displayImage"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "variant": List<dynamic>.from(variant.map((x) => x.toJson())),
    "quantitySold": quantitySold,
    "availability": availability,
    "displayImage": displayImage,
  };
}

class Variant {
  String sizeName;
  String colorName;
  String size;
  String color;
  int listingPrice;
  int sellingPrice;
  String id;
  int discount;

  Variant({
    required this.sizeName,
    required this.colorName,
    required this.size,
    required this.color,
    required this.listingPrice,
    required this.sellingPrice,
    required this.id,
    required this.discount,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    sizeName: json["sizeName"]??'',
    colorName: json["colorName"]??"",
    size: json["size"]??"",
    color: json["color"]??"",
    listingPrice: json["listingPrice"]??0,
    sellingPrice: json["sellingPrice"]??0,
    id: json["_id"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "sizeName": sizeName,
    "colorName": colorName,
    "size": size,
    "color": color,
    "listingPrice": listingPrice,
    "sellingPrice": sellingPrice,
    "_id": id,
    "discount": discount,
  };
}
