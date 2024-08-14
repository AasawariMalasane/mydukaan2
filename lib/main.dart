import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/category_provider.dart';
import 'providers/misc_provider.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';
import 'providers/tab_provider.dart';  // Add this import
import 'repositories/auth_repository.dart';
import 'repositories/cart_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/misc_repository.dart';
import 'repositories/product_repository.dart';
import 'repositories/user_repository.dart';
import 'services/api_service.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Initialize SharedPreferences

  await Hive.initFlutter();
  await HiveService.initBoxes();

  final apiService = ApiService();
  final authRepository = AuthRepository(apiService);
  final cartRepository = CartRepository(apiService);
  final miscRepository = MiscRepository(apiService);
  final productRepository = ProductRepository(apiService);
  final userRepository = UserRepository(apiService);
  final categoryRepository = CategoryRepository(apiService);  // Add this line

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => CartProvider(cartRepository)),
        ChangeNotifierProvider(create: (_) => MiscProvider(miscRepository)),
        ChangeNotifierProvider(create: (_) => ProductProvider(productRepository)),
        ChangeNotifierProvider(create: (_) => UserProvider(userRepository)),
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider(categoryRepository)),  // Add this line
      ],
      child: MyApp(),
    ),
  );
}