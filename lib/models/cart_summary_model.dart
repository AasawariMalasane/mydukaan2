// To parse this JSON data, do
//
//     final CartSummaryModel = CartSummaryModelFromJson(jsonString);

import 'dart:convert';

List<CartSummaryModel> CartSummaryModelFromJson(String str) => List<CartSummaryModel>.from(json.decode(str).map((x) => CartSummaryModel.fromJson(x)));

String CartSummaryModelToJson(List<CartSummaryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartSummaryModel {
  List<Cart> cart;
  Bill bill;
  Wishlist wishlist;

  CartSummaryModel({
    required this.cart,
    required this.bill,
    required this.wishlist,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) => CartSummaryModel(
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
    bill: Bill.fromJson(json["bill"]),
    wishlist: Wishlist.fromJson(json["wishlist"]),
  );

  Map<String, dynamic> toJson() => {
    "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
    "bill": bill.toJson(),
    "wishlist": wishlist.toJson(),
  };
}

class Bill {
  int totalAmount;
  bool couponApplied;
  String couponCode;
  String couponName;
  int couponDiscount;
  int shippingFee;
  int totalAfterCoupon;

  Bill({
    required this.totalAmount,
    required this.couponApplied,
    required this.couponCode,
    required this.couponName,
    required this.couponDiscount,
    required this.shippingFee,
    required this.totalAfterCoupon,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    totalAmount: json["totalAmount"],
    couponApplied: json["couponApplied"],
    couponCode: json["couponCode"],
    couponName: json["couponName"],
    couponDiscount: json["couponDiscount"],
    shippingFee: json["shippingFee"],
    totalAfterCoupon: json["totalAfterCoupon"],
  );

  Map<String, dynamic> toJson() => {
    "totalAmount": totalAmount,
    "couponApplied": couponApplied,
    "couponCode": couponCode,
    "couponName": couponName,
    "couponDiscount": couponDiscount,
    "shippingFee": shippingFee,
    "totalAfterCoupon": totalAfterCoupon,
  };
}

class Cart {
  String productId;
  String productName;
  int listingPrice;
  int sellingPrice;
  int quantity;
  int subTotal;
  String displayImage;
  String sizeName;
  String colorName;
  String variantId;

  Cart({
    required this.productId,
    required this.productName,
    required this.listingPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.subTotal,
    required this.displayImage,
    required this.sizeName,
    required this.colorName,
    required this.variantId,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    productId: json["productId"],
    productName: json["productName"],
    listingPrice: json["listingPrice"],
    sellingPrice: json["sellingPrice"],
    quantity: json["quantity"],
    subTotal: json["subTotal"],
    displayImage: json["displayImage"],
    sizeName: json["sizeName"]??"",
    colorName: json["colorName"]??"",
    variantId: json["variantId"]??"",
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "listingPrice": listingPrice??0,
    "sellingPrice": sellingPrice??0,
    "quantity": quantity??0,
    "subTotal": subTotal??0,
    "displayImage": displayImage??"",
    "sizeName": sizeName??"",
    "colorName": colorName??"",
    "variantId": variantId??"",
  };
}

class Wishlist {
  List<Product> products;
  int currentPage;
  bool hasNextPage;

  Wishlist({
    required this.products,
    required this.currentPage,
    required this.hasNextPage,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    currentPage: json["currentPage"],
    hasNextPage: json["hasNextPage"],
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "currentPage": currentPage,
    "hasNextPage": hasNextPage,
  };
}

class Product {
  String name;
  String displayImage;
  String productId;

  Product({
    required this.name,
    required this.displayImage,
    required this.productId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json["name"]??"",
    displayImage: json["displayImage"]??"",
    productId: json["productId"]??"",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "displayImage": displayImage,
    "productId": productId,
  };
}
