import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../providers/misc_provider.dart';
import '../providers/auth_provider.dart';
import 'cart_screen.dart';
import 'category_screen.dart';
import 'home_screen.dart';
import 'package:badges/badges.dart' as badge;

import 'wishlist_screen.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    print("MainScreen - initState called");
    _pages = [
      HomeScreen(),
      CategoryScreen(),
      CartScreen(),
      WishlistScreen(),
      Container(),
    ];
    print("MainScreen - _pages initialized");
  }

  @override
  Widget build(BuildContext context) {
    print("MainScreen - build called");
    return Consumer2<TabProvider, MiscProvider>(
      builder: (context, tabProvider, miscProvider, child) {
        print("MainScreen - Consumer builder called, currentIndex: ${tabProvider.currentIndex}");
        return Scaffold(
          body: IndexedStack(
            index: tabProvider.currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabProvider.currentIndex,
            onTap: (index) {
              print("MainScreen - Bottom nav item tapped: $index");
              tabProvider.setCurrentIndex(index);
            },
            selectedItemColor: miscProvider.selectedOptionColor,
            unselectedItemColor: miscProvider.fontColor,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: miscProvider.footerColor,
            type: BottomNavigationBarType.fixed,
            items: _buildBottomNavigationBarItems(context),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems(BuildContext context) {
    print("MainScreen - _buildBottomNavigationBarItems called");
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    List<BottomNavigationBarItem> items = [
      _buildNavItem(Icons.home, 'HOME', miscProvider),
      _buildNavItem(Icons.category_outlined, 'CATEGORY', miscProvider),
    ];

    if (authProvider.isLoggedIn) {
      print("MainScreen - User is logged in, adding all items");
      items.addAll([
        _buildCartNavItem(context, miscProvider),
        _buildNavItem(Icons.favorite_border, 'FAVORITE', miscProvider),
        _buildNavItem(Icons.account_circle_outlined, 'PROFILE', miscProvider),
      ]);
    } else {
      print("MainScreen - User is not logged in, adding only cart item");
      items.add(_buildNavItem(Icons.shopping_cart, 'CART', miscProvider));
    }

    return items;
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, MiscProvider miscProvider) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: miscProvider.fontColor),
      activeIcon: Icon(icon, color: miscProvider.selectedOptionColor),
      label: label,
    );
  }

  BottomNavigationBarItem _buildCartNavItem(BuildContext context, MiscProvider miscProvider) {
    return BottomNavigationBarItem(
      icon: Consumer<MiscProvider>(
        builder: (context, miscProvider, child) {
          int cartItemCount = miscProvider.cartAndWishlistProduct.isNotEmpty
              ? miscProvider.cartAndWishlistProduct.first.cartProductsCount
              : 0;
          return badge.Badge(
            position: badge.BadgePosition.topEnd(top: -5, end: -1),
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
            child: Icon(Icons.shopping_cart, color: miscProvider.fontColor),
          );
        },
      ),
      activeIcon: Consumer<MiscProvider>(
        builder: (context, miscProvider, child) {
          int cartItemCount = miscProvider.cartAndWishlistProduct.isNotEmpty
              ? miscProvider.cartAndWishlistProduct.first.cartProductsCount
              : 0;
          return badge.Badge(
            position: badge.BadgePosition.topEnd(top: -5, end: -1),
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
            child: Icon(Icons.shopping_cart, color: miscProvider.selectedOptionColor),
          );
        },
      ),
      label: 'CART',
    );
  }
}