// To parse this JSON data, do
//
//     final shippingAddressModel = shippingAddressModelFromJson(jsonString);

import 'dart:convert';

List<ShippingAddressModel> shippingAddressModelFromJson(String str) => List<ShippingAddressModel>.from(json.decode(str).map((x) => ShippingAddressModel.fromJson(x)));

String shippingAddressModelToJson(List<ShippingAddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShippingAddressModel {
  String shippingAddressId;
  String fullName;
  String mobileNumber;
  String streetAddress;
  String city;
  String state;
  String pincode;
  String type;
  String email;
  bool primary;

  ShippingAddressModel({
    required this.shippingAddressId,
    required this.fullName,
    required this.mobileNumber,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.type,
    required this.email,
    required this.primary,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) => ShippingAddressModel(
    shippingAddressId: json["shippingAddressId"],
    fullName: json["fullName"],
    mobileNumber: json["mobileNumber"],
    streetAddress: json["streetAddress"],
    city: json["city"],
    state: json["state"],
    pincode: json["pincode"],
    type: json["type"],
    email: json["email"],
    primary: json["primary"],
  );

  Map<String, dynamic> toJson() => {
    "shippingAddressId": shippingAddressId,
    "fullName": fullName,
    "mobileNumber": mobileNumber,
    "streetAddress": streetAddress,
    "city": city,
    "state": state,
    "pincode": pincode,
    "type": type,
    "email": email,
    "primary": primary,
  };
}
