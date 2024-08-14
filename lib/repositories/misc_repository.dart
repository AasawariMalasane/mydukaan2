import '../models/cart_wishlist_model.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../config/api_endpoints.dart';
import '../models/banner_model.dart';
import '../models/logo_model.dart';
import '../models/color_model.dart';

class MiscRepository {
  final ApiService _apiService;

  MiscRepository(this._apiService);

  Future<List<BannerModel>> getTopBanner() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getTopBanner);
      final banners = (response['data'] as List).map((e) => BannerModel.fromJson(e)).toList();
      // await HiveService.saveBannerDataToHive('Top', banners);
      return banners;
    } catch (e) {
      return HiveService.getBannerDataFromHive('Top');
    }
  }

  Future<List<BannerModel>> getMiddleBanner() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getMiddleBanner);
      final banners = (response['data'] as List).map((e) => BannerModel.fromJson(e)).toList();
      // await HiveService.saveBannerDataToHive('Middle', banners);
      return banners;
    } catch (e) {
      return HiveService.getBannerDataFromHive('Middle');
    }
  }

  Future<List<BannerModel>> getBottomBanner() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getBottomBanner);
      final banners = (response['data'] as List).map((e) => BannerModel.fromJson(e)).toList();
      // await HiveService.saveBannerDataToHive('Bottom', banners);
      return banners;
    } catch (e) {
      return HiveService.getBannerDataFromHive('Bottom');
    }
  }

  Future<LogoModel> getLogo() async {
    final response = await _apiService.get(ApiEndpoints.getLogo);
    print("response==$response");
    return LogoModel.fromJson(response['data']);
  }

  Future<ColorModel> getColors() async {
    final response = await _apiService.get(ApiEndpoints.getColors);
    print("response==$response");
    return ColorModel.fromJson(response['data']);
  }

  Future<void> applyCoupon(String userId, String couponCode) async {
    await _apiService.patch(
      ApiEndpoints.applyCoupon(userId),
      body: {"couponCode": couponCode},
    );
  }

  Future<void> removeCoupon(String userId) async {
    await _apiService.patch(ApiEndpoints.removeCoupon(userId));
  }

  Future<List<CartAndWishlistProduct>> getCartWishlistProducts(String userId) async {
    final response = await _apiService.get(ApiEndpoints.getCartWishlistProducts(userId));
    print("response==$response");
    return response['data'];
  }
}