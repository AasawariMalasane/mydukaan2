import 'dart:convert';

List<SubcategoryByCatModel> subcategoryByCatModelFromJson(String str) => List<SubcategoryByCatModel>.from(json.decode(str).map((x) => SubcategoryByCatModel.fromJson(x)));

String subcategoryByCatModelToJson(List<SubcategoryByCatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubcategoryByCatModel {
  SubcategoryByCatModel({
    required this.subCategoryId,
    required this.subCategoryName,
  });

  String subCategoryId;
  String subCategoryName;

  factory SubcategoryByCatModel.fromJson(Map<String, dynamic> json) => SubcategoryByCatModel(
    subCategoryId: json["_id"],
    subCategoryName: json["subCategoryName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": subCategoryId,
    "subCategoryName": subCategoryName,
  };
}
