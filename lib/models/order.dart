
import 'dart:convert';

List<OrderModel> OrderModelFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String OrderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  OrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.orderReceived,
    required this.orderStatus,
    required this.deliveryDate,
    required this.items,
  });

  String orderId;
  int orderNumber;
  String orderReceived;
  String orderStatus;
  String deliveryDate;
  int items;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderId: json["orderId"],
    orderNumber: json["orderNumber"],
    orderReceived: json["orderReceived"],
    orderStatus: json["orderStatus"],
    deliveryDate: json["deliveryDate"],
    items: json["items"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "orderNumber": orderNumber,
    "orderReceived": orderReceived,
    "orderStatus": orderStatus,
    "deliveryDate": deliveryDate,
    "items": items,
  };
}
