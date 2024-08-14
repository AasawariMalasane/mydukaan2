import '../models/category_model.dart';
import '../services/api_service.dart';
import '../config/api_endpoints.dart';
import '../models/subcat_model.dart';

class CategoryRepository {
  final ApiService _apiService;

  CategoryRepository(this._apiService);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.get(ApiEndpoints.getCategories);
    return (response['data'] as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  Future<List<SubcategoryByCatModel>> getSubcategories(String categoryId) async {
    final response = await _apiService.get(ApiEndpoints.getSubcategories(categoryId));
    return (response['data'] as List)
        .map((json) => SubcategoryByCatModel.fromJson(json))
        .toList();
  }
}