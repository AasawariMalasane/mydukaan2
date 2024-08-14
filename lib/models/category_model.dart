import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  String? id;
  String? name;
  String? categoryName;
  String? subCategory;
  String? category;
  List<Variant> variant;  // Changed to non-nullable
  String? availability;
  String? displayImage;
  int? averageRating;
  String? categoryModelId;

  CategoryModel({
    this.id,
    this.name,
    this.categoryName,
    this.subCategory,
    this.category,
    this.variant = const [],  // Provide a default empty list
    this.availability,
    this.displayImage,
    this.averageRating,
    this.categoryModelId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["_id"] as String?,
    name: json["name"] as String?,
    categoryName: json["categoryName"] as String?,
    subCategory: json["subCategory"] as String?,
    category: json["category"] as String?,
    variant: (json["variant"] as List<dynamic>?)
        ?.map((x) => Variant.fromJson(x as Map<String, dynamic>))
        .toList() ?? [],
    availability: json["availability"] as String?,
    displayImage: json["displayImage"] as String?,
    averageRating: json["averageRating"] as int?,
    categoryModelId: json["id"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "categoryName": categoryName,
    "subCategory": subCategory,
    "category": category,
    "variant": variant.map((x) => x.toJson()).toList(),
    "availability": availability,
    "displayImage": displayImage,
    "averageRating": averageRating,
    "id": categoryModelId,
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
  String variantId;

  Variant({
    required this.sizeName,
    required this.colorName,
    required this.size,
    required this.color,
    required this.listingPrice,
    required this.sellingPrice,
    required this.id,
    required this.discount,
    required this.variantId,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    sizeName: json["sizeName"] as String? ?? "",
    colorName: json["colorName"] as String? ?? "",
    size: json["size"] as String? ?? "",
    color: json["color"] as String? ?? "",
    listingPrice: json["listingPrice"] as int? ?? 0,
    sellingPrice: json["sellingPrice"] as int? ?? 0,
    id: json["_id"] as String? ?? "",
    discount: json["discount"] as int? ?? 0,
    variantId: json["id"] as String? ?? "",
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
    "id": variantId,
  };
}