import 'dart:convert';

List<CartItemModel> CartItemModelFromJson(String str) => List<CartItemModel>.from(json.decode(str).map((x) => CartItemModel.fromJson(x)));

String CartItemModelToJson(List<CartItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartItemModel {
  String cartId;
  List<Cart> cart;
  int subTotal;
  int shippingFee;
  int total;
  int totalAmount;
  bool couponApplied;
  String couponCode;
  int discountAmount;

  CartItemModel({
    required this.cartId,
    required this.cart,
    required this.subTotal,
    required this.shippingFee,
    required this.total,
    required this.totalAmount,
    required this.couponApplied,
    required this.couponCode,
    required this.discountAmount,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    cartId: json["cartId"],
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
    subTotal: json["subTotal"],
    shippingFee: json["shippingFee"],
    total: json["total"],
    totalAmount: json["totalAmount"],
    couponApplied: json["couponApplied"],
    couponCode: json["couponCode"],
    discountAmount: json["discountAmount"],
  );

  Map<String, dynamic> toJson() => {
    "cartId": cartId,
    "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
    "subTotal": subTotal,
    "shippingFee": shippingFee,
    "total": total,
    "totalAmount": totalAmount,
    "couponApplied": couponApplied,
    "couponCode": couponCode,
    "discountAmount": discountAmount,
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
  String variantId;
  String? sizeName;
  String? colorName;

  Cart({
    required this.productId,
    required this.productName,
    required this.listingPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.subTotal,
    required this.displayImage,
    required this.variantId,
    this.sizeName,
    this.colorName,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    productId: json["productId"],
    productName: json["productName"]??"",
    listingPrice: json["listingPrice"]??0,
    sellingPrice: json["sellingPrice"]??0,
    quantity: json["quantity"]??0,
    subTotal: json["subTotal"]??0,
    displayImage: json["displayImage"],
    variantId: json["variantId"]??"",
    sizeName: json["sizeName"]??"",
    colorName: json["colorName"]??"",
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "listingPrice": listingPrice,
    "sellingPrice": sellingPrice,
    "quantity": quantity,
    "subTotal": subTotal,
    "displayImage": displayImage,
    "variantId": variantId,
    "sizeName": sizeName,
    "colorName": colorName,
  };
}
