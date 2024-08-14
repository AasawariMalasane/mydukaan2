import 'package:flutter/foundation.dart';
import '../models/Shipping_Add_model.dart';
import '../models/wishlist_model.dart';
import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository;

  List<ShippingAddressModel> _addresses = [];
  List<WishlistItemModel> _wishlist = [];
  bool _isLoading = false;
  String? _error;

  UserProvider(this._userRepository);

  List<ShippingAddressModel> get addresses => _addresses;
  List<WishlistItemModel> get wishlist => _wishlist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAddresses(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _addresses = await _userRepository.getShippingAddresses(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress(String userId, ShippingAddressModel address) async {
    try {
      await _userRepository.addShippingAddress(userId, address);
      await fetchAddresses(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeAddress(String userId, String addressId) async {
    try {
      await _userRepository.removeShippingAddress(userId, addressId);
      await fetchAddresses(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchWishlist(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _wishlist = await _userRepository.getWishlist(userId);
      print("_wishlist==$_wishlist");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToWishlist(String productId, String userId) async {
    try {
      await _userRepository.addToWishlist(productId, userId);
      await fetchWishlist(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String productId, String userId) async {
    try {
      await _userRepository.removeFromWishlist(productId, userId);
      await fetchWishlist(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}