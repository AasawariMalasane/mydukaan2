import '../models/homepage_model.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../config/api_endpoints.dart';
import '../models/category_model.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<HomePageProducts>> getHomePageProducts() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getHomePageProducts);
      print("respomse===$response");
      final products = (response['data'] as List).map((e) => HomePageProducts.fromJson(e)).toList();
      print("products---$products");
      // await HiveService.saveGetHomeProductToHive(products);
      return products;
    } catch (e) {
      return HiveService.getGetHomeProductFromHive();
    }
  }

  Future<HomePageProducts> getProductDetails(String productId, String userId) async {
    final response = await _apiService.get(ApiEndpoints.getProductDetails(productId, userId));
    return HomePageProducts.fromJson(response['data'][0]);
  }

  Future<List<HomePageProducts>> getProductsByCategory(String catId, int page, String order) async {
    final response = await _apiService.get(ApiEndpoints.getProductsByCategory(catId, page, order));
    return (response['data']['products'] as List).map((e) => HomePageProducts.fromJson(e)).toList();
  }

  Future<List<HomePageProducts>> searchProducts(String query, int page, String order) async {
    final response = await _apiService.get(ApiEndpoints.searchProducts(query, page, order));
    return (response['data']['products'] as List).map((e) => HomePageProducts.fromJson(e)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getCategories);
      print("response==$response");
      final categories = (response['data'] as List).map((e) => CategoryModel.fromJson(e)).toList();
       print("categories==$categories");
      // await HiveService.saveCategory(categories, isMainCategory: true);
      return categories;
    } catch (e) {
      return HiveService.getCategory(isMainCategory: true);
    }
  }

  Future<List<CategoryModel>> getSubcategories(String catId) async {
    final response = await _apiService.get(ApiEndpoints.getSubcategories(catId));
    return (response['data'] as List).map((e) => CategoryModel.fromJson(e)).toList();
  }
}