import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;
import '../providers/auth_provider.dart';
import '../providers/misc_provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;
  final String title;
  final bool showSearch;
  final bool showWishlist;
  final bool showCart;

  const CustomAppbar({
    Key? key,
    required this.onPressed,
    required this.title,
    this.showSearch = false,
    this.showWishlist = false,
    this.showCart = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final miscProvider = Provider.of<MiscProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return AppBar(
      backgroundColor: miscProvider.headerColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onPressed,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: miscProvider.fontColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        if (showSearch)
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
        if (showWishlist && authProvider.isLoggedIn)
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Navigate to wishlist screen
            },
          ),
        if (showCart)
          Consumer<MiscProvider>(
            builder: (context, miscProvider, child) {
              int cartItemCount = miscProvider.cartAndWishlistProduct.isNotEmpty
                  ? miscProvider.cartAndWishlistProduct.first.cartProductsCount
                  : 0;
              return badge.Badge(
                position: badge.BadgePosition.topEnd(top: 0, end: 3),
                badgeAnimation: badge.BadgeAnimation.rotation(),
                showBadge: cartItemCount > 0,
                badgeContent: Text(
                  cartItemCount.toString(),
                  style: TextStyle(
                    fontSize: 8,
                    color: miscProvider.extraColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                badgeStyle: badge.BadgeStyle(
                  badgeColor: miscProvider.wishListColor,
                ),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    // Navigate to cart screen
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}