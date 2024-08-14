import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_config.dart';
import '../models/category_model.dart';
import '../models/subcat_model.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/misc_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_loader.dart';
import 'main_Screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCategory();
    });
  }

  void _initializeCategory() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.getProductCategories();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      final miscProvider = Provider.of<MiscProvider>(context, listen: false);
      miscProvider.fetchCartWishlistSummary(authProvider.user?.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (v) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
          title: "Product Categories",
          showSearch: true,
          showWishlist: true,
          showCart: true,
        ),
        body: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if (categoryProvider.isLoading) {
              return CustomLoader();
            }
            if (categoryProvider.categories.isEmpty) {
              return Center(child: Text("No data found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)));
            }
            return ListView.builder(
              itemCount: categoryProvider.categories.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int keyIndex) {
                return _buildCategoryCard(context, categoryProvider.categories[keyIndex], keyIndex);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category, int keyIndex) {
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            _buildCategoryHeader(context, category, keyIndex),
            _buildSubcategories(context, category, keyIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, CategoryModel category, int keyIndex) {
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    return InkWell(
      onTap: () => _handleCategoryTap(category, keyIndex),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: AppConfig.baseUrl + category.displayImage!,
            imageBuilder: (context, imageProvider) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            decoration: BoxDecoration(
              color: miscProvider.extraColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              category.categoryName!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategories(BuildContext context, CategoryModel category, int keyIndex) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final miscProvider = Provider.of<MiscProvider>(context);

    if (_currentSelectedIndex != keyIndex) {
      return SizedBox.shrink();
    }
    final subcategories = categoryProvider.getSubcategoriesForCategory(category.id!);
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: categoryProvider.isLoadingSubcategories(category.id!)
            ? Container(
          height: 100,
          child: CustomLoader(),
        )
            : subcategories.isEmpty
            ? SizedBox()
            : GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subcategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 75,
          ),
          itemBuilder: (BuildContext context, int index) {
            return _buildSubcategoryItem(context, subcategories[index]);
          },
        ),
      ),
    );
  }

  Widget _buildSubcategoryItem(BuildContext context, SubcategoryByCatModel subcategory) {
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => null,
      // Uncomment and implement navigation to subcategory detail screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SubcategoryDetailScreen(
      //       subcatId: subcategory.subCategoryId,
      //       subcatName: subcategory.subCategoryName,
      //     ),
      //   ),
      // ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: miscProvider.extraColor,
          border: Border.all(color: Color(0xFFDCDCDC)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            subcategory.subCategoryName,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }

  void _handleCategoryTap(CategoryModel category, int keyIndex) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    setState(() {
      if (_currentSelectedIndex == keyIndex) {
        _currentSelectedIndex = -1;
      } else {
        _currentSelectedIndex = keyIndex;
        categoryProvider.getSubcategories(category.id!);
      }
    });
  }
}