// To parse this JSON data, do
//
//     final generateOrderModel = generateOrderModelFromJson(jsonString);

import 'dart:convert';

List<GenerateOrderModel> generateOrderModelFromJson(String str) => List<GenerateOrderModel>.from(json.decode(str).map((x) => GenerateOrderModel.fromJson(x)));

String generateOrderModelToJson(List<GenerateOrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GenerateOrderModel {
  String orderId;
  int orderNumber;
  String date;
  ShippingAddress shippingAddress;
  String email;
  String deliveryDate;
  List<Product> products;
  int cartTotal;
  int totalAfterCoupon;
  int shippingFees;
  int total;

  GenerateOrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.date,
    required this.shippingAddress,
    required this.email,
    required this.deliveryDate,
    required this.products,
    required this.cartTotal,
    required this.totalAfterCoupon,
    required this.shippingFees,
    required this.total,
  });

  factory GenerateOrderModel.fromJson(Map<String, dynamic> json) => GenerateOrderModel(
    orderId: json["orderId"],
    orderNumber: json["orderNumber"],
    date: json["date"],
    shippingAddress: ShippingAddress.fromJson(json["shippingAddress"]),
    email: json["email"],
    deliveryDate: json["deliveryDate"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    cartTotal: json["cartTotal"],
    totalAfterCoupon: json["totalAfterCoupon"],
    shippingFees: json["ShippingFees"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "orderNumber": orderNumber,
    "date": date,
    "shippingAddress": shippingAddress.toJson(),
    "email": email,
    "deliveryDate": deliveryDate,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "cartTotal": cartTotal,
    "totalAfterCoupon": totalAfterCoupon,
    "ShippingFees": shippingFees,
    "total": total,
  };
}

class Product {
  String product;
  int listingPrice;
  int sellingPrice;
  int quantity;
  String name;
  int subTotal;
  String displayImage;
  String sizeName;
  String colorName;
  String variantId;
  String id;

  Product({
    required this.product,
    required this.listingPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.name,
    required this.subTotal,
    required this.displayImage,
    required this.sizeName,
    required this.colorName,
    required this.variantId,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    product: json["product"],
    listingPrice: json["listingPrice"],
    sellingPrice: json["sellingPrice"],
    quantity: json["quantity"],
    name: json["name"],
    subTotal: json["subTotal"],
    displayImage: json["displayImage"],
    sizeName: json["sizeName"]??"",
    colorName: json["colorName"]??"",
    variantId: json["variantId"]??"",
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "product": product,
    "listingPrice": listingPrice,
    "sellingPrice": sellingPrice,
    "quantity": quantity,
    "name": name,
    "subTotal": subTotal,
    "displayImage": displayImage,
    "sizeName": sizeName,
    "colorName": colorName,
    "variantId": variantId,
    "_id": id,
  };
}

class ShippingAddress {
  String fullName;
  String mobileNumber;
  String streetAddress;
  String city;
  String state;
  String pinCode;
  String email;
  String type;
  bool primary;

  ShippingAddress({
    required this.fullName,
    required this.mobileNumber,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.email,
    required this.type,
    required this.primary,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
    fullName: json["fullName"],
    mobileNumber: json["mobileNumber"],
    streetAddress: json["streetAddress"],
    city: json["city"],
    state: json["state"],
    pinCode: json["pinCode"],
    email: json["email"],
    type: json["type"],
    primary: json["primary"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "mobileNumber": mobileNumber,
    "streetAddress": streetAddress,
    "city": city,
    "state": state,
    "pinCode": pinCode,
    "email": email,
    "type": type,
    "primary": primary,
  };
}
