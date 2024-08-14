import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mydukaanapp2/config/app_config.dart';
import 'package:mydukaanapp2/screens/main_Screen.dart';
import 'package:provider/provider.dart';
import '../models/wishlist_model.dart';
import '../providers/user_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/misc_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_loader.dart';
import 'login_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeWishlist();
  }

  Future<void> _initializeWishlist() async {
    print("WishlistScreen - _initializeWishlist called");
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);

    if (authProvider.isLoggedIn) {
      print("WishlistScreen - User is logged in, fetching wishlist");
      await userProvider.fetchWishlist(authProvider.user!.userId);
      await miscProvider.fetchCartWishlistSummary(authProvider.user!.userId);
    } else {
      print("WishlistScreen - User is not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("WishlistScreen - build called");

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      },
      child: Scaffold(
        appBar: CustomAppbar(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
          title: "My Wishlist",
          showSearch: true,
          showWishlist: false,
          showCart: false,
        ),
        body: FutureBuilder(
          future: _initializationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomLoader();
            }
            return Consumer3<UserProvider, CartProvider, MiscProvider>(
              builder: (context, userProvider, cartProvider, miscProvider, child) {
                print("WishlistScreen - Consumer builder called");
                print("WishlistScreen - isLoading: ${userProvider.isLoading}");
                print("WishlistScreen - wishlist length: ${userProvider.wishlist.length}");

                if (userProvider.isLoading) {
                  return CustomLoader();
                }
                if (userProvider.wishlist.isEmpty) {
                  return Center(child: Text("No Wishlist data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
                }
                return _buildWishlistContent(context, userProvider, cartProvider, miscProvider);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context, UserProvider userProvider, CartProvider cartProvider, MiscProvider miscProvider) {
    return Stack(
      children: [
        ListView.separated(
          padding: EdgeInsets.all(10),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: userProvider.wishlist.length,
          itemBuilder: (context, index) => _buildWishlistItem(context, userProvider, cartProvider, miscProvider, index),
        ),
        if (userProvider.isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CustomLoader()),
            ),
          ),
      ],
    );
  }

  Widget _buildWishlistItem(BuildContext context, UserProvider userProvider, CartProvider cartProvider, MiscProvider miscProvider, int index) {
    final product = userProvider.wishlist[index];
    final isInCart =  miscProvider.cartAndWishlistProduct.isNotEmpty &&
        miscProvider.cartAndWishlistProduct.first.cartProductsId.contains(product.id);
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(id: product.id, previousPage: "WishlistScreen")));
      },
      child: Slidable(
        key: ValueKey(product.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.3,
          children: [
            SlidableAction(
              onPressed: (_) => _removeFromWishlist(context, product.id),
              backgroundColor: miscProvider.extraColor,
              foregroundColor: Colors.black,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.only(right: 5),
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade200),
            color: miscProvider.extraColor,
          ),
          child: Row(
            children: [
              Container(
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: product.displayImage != ""
                        ? NetworkImage(AppConfig.baseUrl + product.displayImage)
                        : AssetImage("assets/images/drawer/logo.png") as ImageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("₹ ${product.variant.first.sellingPrice}"),
                    Text(
                      "₹ ${product.variant.first.listingPrice}",
                      style: TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: miscProvider.headerColor,
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => _handleCartAction(context, product, isInCart),
                  child: Text(
                    isInCart ? "Remove from Cart" : "Add to Cart",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeFromWishlist(BuildContext context, String productId) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (authProvider.isLoggedIn) {
      userProvider.removeFromWishlist(productId, authProvider.user!.userId);
    }
  }

  void _handleCartAction(BuildContext context, WishlistItemModel product, bool isInCart) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }

    if (isInCart) {
      cartProvider.removeFromCart(authProvider.user!.userId, product.variant.first.id, product.id);
    } else {
      cartProvider.addToCart(authProvider.user!.userId, product.variant.first.id, 1,product.id);
    }
  }
}