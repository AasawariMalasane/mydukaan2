import 'package:flutter/foundation.dart';
import '../models/homepage_model.dart';
import '../repositories/product_repository.dart';
import '../models/category_model.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository;

  List<HomePageProducts> _products = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  ProductProvider(this._productRepository);

  List<HomePageProducts> get products => _products;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final products = await _productRepository.getHomePageProducts();
      _products = products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _productRepository.getCategories();
      print("_categories==$_categories");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}