import 'package:flutter/foundation.dart';
import '../repositories/category_repository.dart';
import '../models/category_model.dart';
import '../models/subcat_model.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _categoryRepository;

  CategoryProvider(this._categoryRepository);

  List<CategoryModel> _categories = [];
  Map<String, List<SubcategoryByCatModel>> _subcategoriesMap = {};
  Map<String, bool> _loadingSubcategories = {};
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<SubcategoryByCatModel> getSubcategoriesForCategory(String categoryId) =>
      _subcategoriesMap[categoryId] ?? [];

  bool isLoadingSubcategories(String categoryId) =>
      _loadingSubcategories[categoryId] ?? false;

  Future<void> getProductCategories() async {
    if (_categories.isNotEmpty) return; // Don't fetch if already loaded

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _categoryRepository.getCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubcategories(String categoryId) async {
    if (_subcategoriesMap.containsKey(categoryId)) return; // Don't fetch if already loaded

    _loadingSubcategories[categoryId] = true;
    _error = null;
    notifyListeners();

    try {
      final subcategories = await _categoryRepository.getSubcategories(categoryId);
      _subcategoriesMap[categoryId] = subcategories;
      _loadingSubcategories[categoryId] = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _loadingSubcategories[categoryId] = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSubcategories(String categoryId) {
    _subcategoriesMap.remove(categoryId);
    notifyListeners();
  }

  void clearAllSubcategories() {
    _subcategoriesMap.clear();
    notifyListeners();
  }

  void clearAll() {
    _categories.clear();
    _subcategoriesMap.clear();
    _loadingSubcategories.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}