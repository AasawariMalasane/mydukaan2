import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cart_wishlist_model.dart';
import '../repositories/misc_repository.dart';
import '../models/banner_model.dart';
import '../models/logo_model.dart';
import '../models/color_model.dart';
import '../utils/app_colors.dart';

class MiscProvider with ChangeNotifier {
  final MiscRepository _miscRepository;

  List<BannerModel> _topBanners = [];
  List<BannerModel> _middleBanners = [];
  List<BannerModel> _bottomBanners = [];
  List<CartAndWishlistProduct> _cartAndWishlistProduct=[];
  LogoModel? _logo;
  ColorModel? _colors;
  bool _isLoading = false;
  String? _error;

  MiscProvider(this._miscRepository);

  List<BannerModel> get topBanners => _topBanners;
  List<BannerModel> get middleBanners => _middleBanners;
  List<BannerModel> get bottomBanners => _bottomBanners;
  LogoModel? get logo => _logo;
  ColorModel? get colors => _colors;
  List<CartAndWishlistProduct> get cartAndWishlistProduct => _cartAndWishlistProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Color get headerColor => AppColors.headerColor;
  Color get footerColor => AppColors.footerColor;
  Color get sidebarColor => AppColors.sidebarColor;
  Color get extraColor => AppColors.extraColor;
  Color get wishListColor => AppColors.wishListColor;
  Color get fontColor => AppColors.fontColor;
  Color get selectedOptionColor => AppColors.selectedOptionColor;


  Future<void> fetchBanners() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _topBanners = await _miscRepository.getTopBanner();
      _middleBanners = await _miscRepository.getMiddleBanner();
      _bottomBanners = await _miscRepository.getBottomBanner();
      print("_middleBanners==$_middleBanners");
      print("_bottomBanners==$_bottomBanners");
      _isLoading = false;
      notifyListeners();
    } catch (e) { print("e==$e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLogo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _logo = await _miscRepository.getLogo();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchColors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _colors = await _miscRepository.getColors();
      _updateAppColors(_colors!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  void _updateAppColors(ColorModel colorModel) {
    AppColors.updateDynamicColors(
      header: _parseColor(colorModel.headerColor),
      footer: _parseColor(colorModel.footerColor),
      sidebar: _parseColor(colorModel.sidebarColor),
      extra: _parseColor(colorModel.extraColor),
      wishList: _parseColor(colorModel.wishListColor),
      font: _parseColor(colorModel.fontColor),
      selectedOption: _parseColor(colorModel.selectedOptionColor),
    );
  }

  Color _parseColor(String colorString) {
    return Color(int.parse(colorString.replaceAll('#', '0xFF')));
  }

  Future<void> fetchCartWishlistSummary(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _cartAndWishlistProduct = await _miscRepository.getCartWishlistProducts(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> applyCoupon(String userId, String couponCode) async {
    try {
      await _miscRepository.applyCoupon(userId, couponCode);
      // You might want to refresh the cart here
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeCoupon(String userId) async {
    try {
      await _miscRepository.removeCoupon(userId);
      // You might want to refresh the cart here
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}