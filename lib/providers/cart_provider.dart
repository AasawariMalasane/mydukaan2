import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/cart_summary_model.dart';
import '../repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _cartRepository;

  List<CartItemModel> _cartItems = [];
  CartSummaryModel? _cartSummary;
  bool _isLoading = false;
  String? _error;

  CartProvider(this._cartRepository);

  List<CartItemModel> get cartItems => _cartItems;
  CartSummaryModel? get cartSummary => _cartSummary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCart(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cartItems = await _cartRepository.getCart(userId);
      _cartSummary = await _cartRepository.getCartSummary(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(String productId, String userId, int quantity, String variantId) async {
    try {
      await _cartRepository.addToCart(productId, userId, quantity, variantId);
      await fetchCart(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String productId, String userId, String variantId) async {
    try {
      await _cartRepository.removeFromCart(productId, userId, variantId);
      await fetchCart(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateCartQuantity(String productId, String userId, int quantity, String variantId) async {
    try {
      await _cartRepository.updateCartQuantity(productId, userId, quantity, variantId);
      await fetchCart(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}