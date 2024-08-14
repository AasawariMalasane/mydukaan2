import 'package:flutter/material.dart';
import 'package:mydukaanapp2/config/app_config.dart';
import 'package:mydukaanapp2/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/misc_provider.dart';
import '../providers/product_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/category_list.dart';
import '../utils/app_colors.dart';
import '../utils/helpers.dart';
import '../models/homepage_model.dart';
import '../widgets/custom_loader.dart';
import '../widgets/productcard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _actionLoader = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHomeData();
    });
  }

  Future<void> _loadHomeData() async {
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await Future.wait([
        miscProvider.fetchBanners(),
        miscProvider.fetchColors(),
        productProvider.fetchProducts(),
        productProvider.fetchCategories(),
        if (authProvider.isLoggedIn) miscProvider.fetchCartWishlistSummary(authProvider.user!.userId),
      ]);
    } catch (e) {
      Helpers.showToast('Error loading data: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawerEdgeDragWidth: MediaQuery.sizeOf(context).width/1.5,
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: _isLoading
            ? CustomLoader()
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreeting(context),
                const SizedBox(height: 16),
                _buildSearchBar(context),
                const SizedBox(height: 16),
                _buildBannerCarousel(),
                SizedBox(height: 15),
                _buildCategoryList(),
                SizedBox(height: 10),
                _buildProductSections(),
                _buildMiddleBanner(),
                _buildBottomProductSections(),
                _buildBottomBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      // leading: Icon,
      title: Text('Home'),
      actions: [
        Consumer2<MiscProvider, AuthProvider>(
          builder: (context, miscProvider, authProvider, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart,color: miscProvider.fontColor,),
                  onPressed: () {
                    if (authProvider.isLoggedIn) {
                      // Navigate to cart screen
                    } else {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    }
                  },
                ),
                if (authProvider.isLoggedIn && miscProvider.cartAndWishlistProduct.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${miscProvider.cartAndWishlistProduct.first.cartProductsCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        String userName = authProvider.isLoggedIn ? authProvider.user?.firstName ?? 'Guest' : 'Guest';
        return Text(
          'Hi, $userName',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Provider.of<MiscProvider>(context).fontColor,
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            cursorColor: AppColors.lightTextColor,
            readOnly: true,
            decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightTextColor),
                prefixIcon:const Icon(Icons.search, color: AppColors.lightTextColor),
                border: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                disabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.all(8)
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 48,
          width: 48,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accentColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Image.asset("assets/images/filter.png",),
        ),
      ],
    );
  }


  Widget _buildBannerCarousel() {
    return Consumer<MiscProvider>(
      builder: (context, miscProvider, child) {
        if (miscProvider.topBanners.isEmpty) {
          return SizedBox.shrink();
        }
        return BannerCarousel(banners: miscProvider.topBanners);
      },
    );
  }

  Widget _buildCategoryList() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.categories.isEmpty) {
          return SizedBox.shrink();
        }
        return CategoryList(
          categories: productProvider.categories,
          onCategoryTap: (category) {
            // Navigate to category products screen
          },
        );
      },
    );
  }

  Widget _buildProductSections() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Column(
          children: productProvider.products.take(2).map((section) => _buildProductSection(section)).toList(),
        );
      },
    );
  }

  Widget _buildMiddleBanner() {
    return Consumer<MiscProvider>(
      builder: (context, miscProvider, child) {
        if (miscProvider.middleBanners.isEmpty) {
          return SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => ProductDetailPage(id: miscProvider.middleBanners.first.productId, previouspage: "Homepage"),
              // ));
            },
            child: CachedNetworkImage(
              imageUrl: AppConfig.baseUrl + miscProvider.middleBanners.first.bannerImage,
              imageBuilder: (context, imageProvider) => Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomProductSections() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Column(
          children: productProvider.products.skip(2).map((section) => _buildProductSection(section)).toList(),
        );
      },
    );
  }

  Widget _buildBottomBanner() {
    return Consumer<MiscProvider>(
      builder: (context, miscProvider, child) {
        if (miscProvider.bottomBanners.isEmpty) {
          return SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => ProductDetailPage(id: miscProvider.bottomBanners.first.productId, previouspage: "Homepage"),
              // ));
            },
            child: CachedNetworkImage(
              imageUrl: AppConfig.baseUrl + miscProvider.bottomBanners.first.bannerImage,
              imageBuilder: (context, imageProvider) => Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductSection(HomePageProducts section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            section.id,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.products.length,
            itemBuilder: (context, index) => _buildProductCard(section.products[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Consumer2<MiscProvider, AuthProvider>(
      builder: (context, miscProvider, authProvider, child) {
        bool isInCart = miscProvider.cartAndWishlistProduct.isNotEmpty &&
            miscProvider.cartAndWishlistProduct.first.cartProductsId.contains(product.id);
        bool isInWishlist = miscProvider.cartAndWishlistProduct.isNotEmpty &&
            miscProvider.cartAndWishlistProduct.first.wishlistProductsId.contains(product.id);
        return ProductCard(
          product: product,
          isInCart: isInCart,
          isInWishlist: isInWishlist,
          onAddToCart: () => _handleAddToCart(product, authProvider,miscProvider),
          onRemoveFromCart: () => _handleRemoveFromCart(product, authProvider,miscProvider),
          onAddToWishlist: () => _handleAddToWishlist(product, authProvider,miscProvider),
          onRemoveFromWishlist: () => _handleRemoveFromWishlist(product, authProvider,miscProvider),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         ProductDetailPage(id: product.id, previouspage: "Homepage"),
            //   ),
            // );
          }
        );
      },
    );
  }

  void _handleAddToCart(Product product, AuthProvider authProvider,MiscProvider miscProvider) {
    print("object");
    if (authProvider.isLoggedIn) {
      print("object2");
      Helpers.showLoadingDialog(context);
      Provider.of<CartProvider>(context, listen: false)
          .addToCart(product.id, authProvider.user!.userId, 1, product.variant.first.variant1!)
          .then((_) {
          miscProvider.fetchCartWishlistSummary(authProvider.user!.userId);
            Helpers.hideLoadingDialog(context);
      });
    } else {
       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void _handleRemoveFromCart(Product product, AuthProvider authProvider,MiscProvider miscProvider) {
    print("object");
    Helpers.showLoadingDialog(context);
    Provider.of<CartProvider>(context, listen: false)
        .removeFromCart(product.id, authProvider.user!.userId, product.variant.first.variant1!)
        .then((_)  {
      print("object2");
          miscProvider.fetchCartWishlistSummary(authProvider.user!.userId);
    Helpers.hideLoadingDialog(context);
  }
  );
  }

  void _handleAddToWishlist(Product product, AuthProvider authProvider,MiscProvider miscProvider) {
    if (authProvider.isLoggedIn) {
      Helpers.showLoadingDialog(context);
      Provider.of<UserProvider>(context, listen: false)
          .addToWishlist(product.id, authProvider.user!.userId)
          .then((_){
        miscProvider.fetchCartWishlistSummary(authProvider.user!.userId);
        Helpers.hideLoadingDialog(context);
      });
    } else {
       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void _handleRemoveFromWishlist(Product product, AuthProvider authProvider,MiscProvider miscProvider) {
    Helpers.showLoadingDialog(context);
    Provider.of<UserProvider>(context, listen: false)
        .removeFromWishlist(product.id, authProvider.user!.userId)
        .then((_) {
      miscProvider.fetchCartWishlistSummary(authProvider.user!.userId);
      Helpers.hideLoadingDialog(context);
    });
  }
}