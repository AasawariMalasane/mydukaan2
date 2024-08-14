import '../models/generateorder_model.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import '../config/api_endpoints.dart';

class OrderRepository {
  final ApiService _apiService;

  OrderRepository(this._apiService);

  Future<GenerateOrderModel> generateOrder(String userId, String addressId, String deliveryDate, String orderNote) async {
    final response = await _apiService.post(
      ApiEndpoints.generateOrder(userId, addressId),
      body: {
        "deliveryDate": deliveryDate,
        "orderNote": orderNote
      },
    );
    return GenerateOrderModel.fromJson(response['data'][0]);
  }

  Future<OrderModel> getOrder(String userId, String orderId) async {
    final response = await _apiService.get(ApiEndpoints.getOrder(userId, orderId));
    return OrderModel.fromJson(response['data'][0]);
  }

  Future<List<OrderModel>> getOrdersInProgress(String userId) async {
    final response = await _apiService.get(ApiEndpoints.getOrdersInProgress(userId));
    return (response['data'] as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<List<OrderModel>> getCompletedOrders(String userId) async {
    final response = await _apiService.get(ApiEndpoints.getCompletedOrders(userId));
    return (response['data'] as List).map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<void> cancelOrder(String orderId, String userId) async {
    await _apiService.patch(ApiEndpoints.cancelOrder(orderId, userId));
  }

  Future<void> updatePaymentStatus(String orderId, String razorpayId) async {
    await _apiService.patch(
      ApiEndpoints.updatePaymentStatus(orderId),
      body: {
        "paymentVerification": "true",
        "razorpayId": razorpayId
      },
    );
  }
}