import '../models/Shipping_Add_model.dart';
import '../services/api_service.dart';
import '../config/api_endpoints.dart';
import '../models/wishlist_model.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<void> addShippingAddress(String userId, ShippingAddressModel address) async {
    await _apiService.post(
      ApiEndpoints.addShippingAddress(userId, address.type),
      body: address.toJson(),
    );
  }

  Future<List<ShippingAddressModel>> getShippingAddresses(String userId) async {
    final response = await _apiService.get(ApiEndpoints.getShippingAddress(userId));
    return (response['data'] as List).map((e) => ShippingAddressModel.fromJson(e)).toList();
  }

  Future<void> removeShippingAddress(String userId, String addressId) async {
    await _apiService.patch(ApiEndpoints.removeShippingAddress(userId, addressId));
  }

  Future<void> setPrimaryAddress(String userId, String addressId) async {
    await _apiService.patch(ApiEndpoints.setPrimaryAddress(userId, addressId));
  }

  Future<void> editShippingAddress(String userId, String addressId, ShippingAddressModel address) async {
    await _apiService.patch(
      ApiEndpoints.editShippingAddress(userId, addressId),
      body: address.toJson(),
    );
  }

  Future<void> addToWishlist(String productId, String userId) async {
    await _apiService.post(ApiEndpoints.addToWishlist(productId, userId));
  }

  Future<void> removeFromWishlist(String productId, String userId) async {
    await _apiService.patch(ApiEndpoints.removeFromWishlist(productId, userId));
  }

  Future<List<WishlistItemModel>> getWishlist(String userId) async {
    final response = await _apiService.get(ApiEndpoints.getWishlist(userId));
    print("getWishlist===$getWishlist");
    return (response['data']['wishlistProducts']['wishlist'] as List)
        .map((e) => WishlistItemModel.fromJson(e)).toList();
  }

  Future<void> setLocation(String userId, String location) async {
    await _apiService.post(
      ApiEndpoints.setLocation(userId),
      body: {"location": location},
    );
  }
}