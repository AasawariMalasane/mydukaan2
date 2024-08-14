import '../config/app_config.dart';
import '../models/cart_item_model.dart';
import '../models/cart_summary_model.dart';
import '../services/api_service.dart';
import '../config/api_endpoints.dart';

class CartRepository {
  final ApiService _apiService;

  CartRepository(this._apiService);

  Future<void> addToCart(String productId, String userId, int quantity, String variantId) async {
    await _apiService.post(
      ApiEndpoints.addToCart(productId, userId),
      body: {
        "quantity": quantity,
        "variantId": variantId,
        "vendorId": AppConfig.vendorId
      },
    );
  }

  Future<void> updateCartQuantity(String productId, String userId, int quantity, String variantId) async {
    await _apiService.post(
      ApiEndpoints.updateCartQuantity,
      body: {
        "quantity": quantity,
        "productId": productId,
        "userId": userId,
        "variantId": variantId
      },
    );
  }

  Future<void> removeFromCart(String productId, String userId, String variantId) async {
    await _apiService.post(
      ApiEndpoints.removeFromCart,
      body: {
        "productId": productId,
        "userId": userId,
        "variantId": variantId
      },
    );
  }

  Future<List<CartItemModel>> getCart(String userId) async {
    final response = await _apiService.get(ApiEndpoints.getCart(userId));
    return (response['data'] as List).map((e) => CartItemModel.fromJson(e)).toList();
  }

  Future<CartSummaryModel> getCartSummary(String userId) async {
    final response = await _apiService.get(ApiEndpoints.getCartSummary(userId));
    return CartSummaryModel.fromJson(response['data'][0]);
  }
}