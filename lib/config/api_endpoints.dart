import 'app_config.dart';

class ApiEndpoints {
  static String get baseUrl => AppConfig.baseUrl;

  // Auth
  static String login = '$baseUrl/user/signup';
  static String editProfile(String id) => '$baseUrl/user/edit/profile/$id';
  static String getProfile(String id) => '$baseUrl/user/profile/$id';
  static String signOut(String id) => '$baseUrl/user/signout/$id';

  // Address
  static String addShippingAddress(String id, String type) =>
      '$baseUrl/user/add/shippingAddress/$id?addressType=$type';
  static String getShippingAddress(String id) =>
      '$baseUrl/user/get/shippingAddress/$id';
  static String removeShippingAddress(String userId, String addressId) =>
      '$baseUrl/user/remove/shippingAddress/$userId/$addressId';
  static String setPrimaryAddress(String userId, String addressId) =>
      '$baseUrl/user/set/shippingAddress/primary/$userId/$addressId';
  static String editShippingAddress(String userId, String addressId) =>
      '$baseUrl/user/edit/shippingAddress/$userId/$addressId';

  // Banners
  static String getTopBanner = '$baseUrl/user/bannerImages/${AppConfig.vendorId}?page=1&bannerPosition=Top';
  static String getMiddleBanner = '$baseUrl/user/bannerImages/${AppConfig.vendorId}?page=1&bannerPosition=Middle';
  static String getBottomBanner = '$baseUrl/user/bannerImages/${AppConfig.vendorId}?page=1&bannerPosition=Bottom';

  // Categories
  static String getCategories = '$baseUrl/user/get-all/category?vendorId=${AppConfig.vendorId}&sort=asc';
  static String getSubcategories(String catId) =>
      '$baseUrl/user/get-all/subCategory?vendorId=${AppConfig.vendorId}&categoryId=$catId&sort=asc';

  // Products
  static String getHomePageProducts = '$baseUrl/user/get/homepage/products/${AppConfig.vendorId}';
  static String getProductDetails(String productId, String userId) =>
      '$baseUrl/user/product/$productId/$userId';
  static String getProductsByCategory(String catId, int page, String order) =>
      '$baseUrl/user/get/products/category/$catId/${AppConfig.vendorId}?page=$page&order=$order';
  static String getProductsBySubcategory(String subcatId, int page, String order) =>
      '$baseUrl/user/get/products/subCategory/$subcatId/${AppConfig.vendorId}?page=$page&order=$order';
  static String searchProducts(String query, int page, String order) =>
      '$baseUrl/user/products/${AppConfig.vendorId}?search=$query&availability=in stock&productType=$order&newest=newest&page=$page&limit=10';

  // Cart
  static String addToCart(String productId, String userId) =>
      '$baseUrl/user/add/product/cart/$productId/$userId';
  static String updateCartQuantity = '$baseUrl/user/update/cart/product/quantity';
  static String removeFromCart = '$baseUrl/user/remove/product/cart';
  static String getCart(String userId) => '$baseUrl/user/get/cart/$userId';
  static String getCartSummary(String userId) =>
      '$baseUrl/user/get/cartsummary/$userId/${AppConfig.vendorId}';

  // Wishlist
  static String addToWishlist(String productId, String userId) =>
      '$baseUrl/user/add/productToWishlist/$productId/$userId';
  static String removeFromWishlist(String productId, String userId) =>
      '$baseUrl/user/remove/productFromWishlist/$productId/$userId';
  static String getWishlist(String userId) => '$baseUrl/user/wishlistData/$userId';

  // Orders
  static String generateOrder(String userId, String addressId) =>
      '$baseUrl/user/generate/order/$userId/$addressId/${AppConfig.vendorId}';
  static String getOrder(String userId, String orderId) =>
      '$baseUrl/user/get/order/$userId/$orderId';
  static String getOrdersInProgress(String userId) =>
      '$baseUrl/user/orders/progress/$userId';
  static String getCompletedOrders(String userId) =>
      '$baseUrl/user/orders/completed/$userId';
  static String cancelOrder(String orderId, String userId) =>
      '$baseUrl/user/cancel/order/$orderId/$userId';
  static String updatePaymentStatus(String orderId) =>
      '$baseUrl/user/order/changePaymentStatus/$orderId';

  // Reviews
  static String addReview(String productId, String userId) =>
      '$baseUrl/user/product/add/review/$productId/$userId';

  // Coupons
  static String applyCoupon(String userId) =>
      '$baseUrl/user/cart/applyCoupon/$userId/${AppConfig.vendorId}';
  static String removeCoupon(String userId) =>
      '$baseUrl/user/cart/removeCoupon/$userId/${AppConfig.vendorId}';

  // Misc
  static String setLocation(String userId) => '$baseUrl/user/set/location/$userId';
  static String getLogo = '$baseUrl/user/logo/${AppConfig.vendorId}';
  static String getColors = '$baseUrl/user/get/color/${AppConfig.vendorId}';
  static String getCartWishlistProducts(String userId) =>
      '$baseUrl/user/cart/wishlist/product/$userId';
}