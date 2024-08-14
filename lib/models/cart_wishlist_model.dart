import 'dart:convert';

List<CartAndWishlistProduct> cartAndWishlistProductFromJson(String str) => List<CartAndWishlistProduct>.from(json.decode(str).map((x) => CartAndWishlistProduct.fromJson(x)));

String cartAndWishlistProductToJson(List<CartAndWishlistProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartAndWishlistProduct {
  CartAndWishlistProduct({
    required this.cartProductsId,
    required this.cartProductsCount,
    required this.wishlistProductsId,
    required this.wishlistProductsCount,
  });

  List<String> cartProductsId;
  int cartProductsCount;
  List<String> wishlistProductsId;
  int wishlistProductsCount;

  factory CartAndWishlistProduct.fromJson(Map<String, dynamic> json) => CartAndWishlistProduct(
    cartProductsId: List<String>.from(json["cartProductsId"].map((x) => x)),
    cartProductsCount: json["cartProductsCount"],
    wishlistProductsId: List<String>.from(json["wishlistProductsId"].map((x) => x)),
    wishlistProductsCount: json["wishlistProductsCount"],
  );

  Map<String, dynamic> toJson() => {
    "cartProductsId": List<dynamic>.from(cartProductsId.map((x) => x)),
    "cartProductsCount": cartProductsCount,
    "wishlistProductsId": List<dynamic>.from(wishlistProductsId.map((x) => x)),
    "wishlistProductsCount": wishlistProductsCount,
  };
}
