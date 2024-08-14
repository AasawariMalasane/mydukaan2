import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../providers/misc_provider.dart';
import '../providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final miscProvider = Provider.of<MiscProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
      backgroundColor: miscProvider.sidebarColor,
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(context, miscProvider, authProvider),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    title: "Home",
                    // onTap: () => Navigator.pop(context),
                  ),
                  if (authProvider.isLoggedIn)
                    _buildDrawerItem(
                      icon: Icons.shopping_cart_outlined,
                      title: "My Orders",
                      // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryPage())),
                    ),
                  _buildDrawerItem(
                    icon: Icons.contact_support_outlined,
                    title: "Contact Us",
                    // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs())),
                  ),
                  _buildDrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy Policy",
                    // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PoliciesPage(type: "Privacy Policy"))),
                  ),
                  _buildDrawerItem(
                    icon: Icons.receipt_long_rounded,
                    title: "Terms and Conditions",
                    // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PoliciesPage(type: "Terms and Condition"))),
                  ),
                  _buildDrawerItem(
                    icon: Icons.fire_truck_outlined,
                    title: "Return Policy",
                    // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PoliciesPage(type: "Return Policy and Cancellation"))),
                  ),
                  // if (Platform.isAndroid && miscProvider.rateOnPlaystore.isNotEmpty)
                  //   _buildDrawerItem(
                  //     icon: Icons.star_rate_outlined,
                  //     title: "Rate Us on Play Store",
                  //     onTap: () => launchUrl(Uri.parse(miscProvider.rateOnPlaystore)),
                  //   ),
                  // if (Platform.isIOS && miscProvider.rateOnAppstore.isNotEmpty)
                  //   _buildDrawerItem(
                  //     icon: Icons.star_rate_outlined,
                  //     title: "Rate Us on App Store",
                  //     onTap: () => launchUrl(Uri.parse(miscProvider.rateOnAppstore)),
                  //   ),
                  _buildDrawerItem(
                    icon: authProvider.isLoggedIn ? Icons.logout : Icons.login,
                    title: authProvider.isLoggedIn ? "Logout" : "Login",
                    // onTap: () => _handleAuthAction(context, authProvider),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerFooter(context, miscProvider),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, MiscProvider miscProvider, AuthProvider authProvider) {
    var firstName= authProvider.user?.firstName??"";
    var lastName= authProvider.user?.lastName??'';
    return UserAccountsDrawerHeader(
      arrowColor: miscProvider.fontColor,
      decoration: BoxDecoration(color: miscProvider.sidebarColor),
      accountName: Text(firstName +" " + lastName,),
      accountEmail: Text(authProvider.user?.email ?? ''),
      currentAccountPicture: CircleAvatar(
        backgroundImage: authProvider.user?.avatar != null
            ? NetworkImage(AppConfig.baseUrl + authProvider.user!.avatar)
            : AssetImage("assets/images/categories/profile_pic.png") as ImageProvider,
      ),
    );
  }
  //required VoidCallback onTap
  Widget _buildDrawerItem({required IconData icon, required String title, }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      // onTap: onTap,
    );
  }

  Widget _buildDrawerFooter(BuildContext context, MiscProvider miscProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     if (miscProvider.logo != null)
          //       Image.network(AppConfig.baseUrl + miscProvider.logo!.logoImage, height: 50),
          //     Row(
          //       children: [
          //         if (miscProvider.facebookUrl != null)
          //           IconButton(
          //             icon: Icon(Icons.facebook, color: Colors.white70),
          //             onPressed: () => launchUrl(Uri.parse(miscProvider.facebookUrl!)),
          //           ),
          //         if (miscProvider.instagramUrl != null)
          //           IconButton(
          //             icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.white70),
          //             onPressed: () => launchUrl(Uri.parse(miscProvider.instagramUrl!)),
          //           ),
          //       ],
          //     ),
          //   ],
          // ),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse("https://techgigs.in/")),
            child: Text(
              "Design and Developed by TechGigs LLP",
              style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  // void _handleAuthAction(BuildContext context, AuthProvider authProvider) {
  //   if (authProvider.isLoggedIn) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Logout"),
  //           content: Text("Are you sure you want to logout?"),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text("Cancel"),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //             TextButton(
  //               child: Text("Logout"),
  //               onPressed: () {
  //                 authProvider.logout();
  //                 Navigator.of(context).pop();
  //                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  //   }
  // }
}