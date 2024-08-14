import 'package:flutter/material.dart';
import 'package:mydukaanapp2/config/app_config.dart';
import 'package:mydukaanapp2/screens/main_Screen.dart';
import 'package:mydukaanapp2/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/misc_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_loader.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("WishlistScreen - addPostFrameCallback called");
      _initializeCartlist();
    });
  }
  void _initializeCartlist() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);

    miscProvider.fetchColors();
    if (authProvider.isLoggedIn) {
      cartProvider.fetchCart(authProvider.user!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: "Cart",
          showSearch: false,
          showWishlist: false,
          showCart: false,
        ),
        body: SafeArea(
          child: Consumer2<CartProvider, MiscProvider>(
            builder: (context, cartProvider, miscProvider, child) {
              if (cartProvider.isLoading || miscProvider.isLoading) {
                return CustomLoader();
              }
              if (cartProvider.cartItems.isEmpty) {
                return Center(child: Text("No Cart data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
              }
              return _buildCartContent(context, cartProvider, miscProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartProvider cartProvider, MiscProvider miscProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCartItemsList(cartProvider, miscProvider),
            SizedBox(height: 10),
            Divider(thickness: 2),
            SizedBox(height: 10),
            _buildOrderSummary(cartProvider),
            SizedBox(height: 30),
            _buildCheckoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemsList(CartProvider cartProvider, MiscProvider miscProvider) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartProvider.cartItems.length,
      itemBuilder: (context, index) => _buildCartItem(context, cartProvider, miscProvider, index),
    );
  }

  Widget _buildCartItem(BuildContext context, CartProvider cartProvider, MiscProvider miscProvider, int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartItem = cartProvider.cartItems.first.cart[index];
    return GestureDetector(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(id: cartItem.productId, previousPage: "CartScreen")));
      },
      child: Slidable(
        key: ValueKey(cartProvider.cartItems.first.cartId),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.3,
          children: [
            SlidableAction(
              onPressed: (_) => cartProvider.removeFromCart(cartItem.variantId, cartItem.productId,authProvider.user?.userId),
              backgroundColor: miscProvider.extraColor,
              foregroundColor: Colors.black,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: _buildCartItemContent(context, cartItem, cartProvider, miscProvider),
      ),
    );
  }

  Widget _buildCartItemContent(BuildContext context, Cart cartItem, CartProvider cartProvider, MiscProvider miscProvider) {
    return Container(
      padding: EdgeInsets.only(right: 5),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey.shade300, blurStyle: BlurStyle.outer)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: cartItem.displayImage != ""
                    ? NetworkImage(AppConfig.baseUrl + cartItem.displayImage)
                    : AssetImage("assets/images/drawer/logo.png") as ImageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 10),
          _buildCartItemDetails(context, cartItem),
          Spacer(),
          _buildQuantityControl(context, cartItem, cartProvider, miscProvider),
        ],
      ),
    );
  }

  Widget _buildCartItemDetails(BuildContext context, Cart cartItem) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: Text(cartItem.productName, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, height: 1), maxLines: 2, overflow: TextOverflow.ellipsis)),
          Row(
            children: [
              Text("₹ ${cartItem.sellingPrice}", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(width: 5),
              Text("₹ ${cartItem.listingPrice}", style: TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough)),
            ],
          ),
          if (cartItem.sizeName != "") Text(cartItem.sizeName!, style: TextStyle(fontSize: 11)),
          if (cartItem.colorName != "") Text(cartItem.colorName!, style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(BuildContext context, Cart cartItem, CartProvider cartProvider, MiscProvider miscProvider) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: miscProvider.headerColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => cartProvider.updateCartQuantity(cartItem.variantId, cartItem.productId, cartItem.quantity - 1,authProvider.user?.userId),
            padding: EdgeInsets.zero,
            icon: Icon(Icons.remove, color: Colors.white, size: 20),
          ),
          Text(cartItem.quantity.toString(), style: TextStyle(color: Colors.white)),
          IconButton(
            onPressed: () => cartProvider.updateCartQuantity(cartItem.variantId, cartItem.productId, cartItem.quantity + 1,authProvider.user?.userId),
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Column(
      children: [
        _buildSummaryRow("Subtotal", "₹ ${cartProvider.cartItems.first.couponApplied}"),
        _buildSummaryRow("Shipping Charges", "+ ₹ ${cartProvider.cartItems.first.shippingFee}"),
        if (cartProvider.cartItems.first.couponApplied)
          _buildSummaryRow("Coupon Code Applied", "- ₹ ${cartProvider.cartItems.first.discountAmount}"),
        Divider(),
        _buildSummaryRow("Total Amount", "₹ ${cartProvider.cartItems.first.totalAmount}", isBold: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButton(
        text: "Checkout",
        backgroundColor: miscProvider.headerColor,
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectAddressScreen()));
        }
      ),
    );
  }
}