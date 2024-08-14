import 'package:hive/hive.dart';
import 'package:mydukaanapp2/models/homepage_model.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';


class HiveService {
  static Future<void> initBoxes() async {
    await Hive.openBox<HomePageProducts>('getHomeProducts');
    await Hive.openBox<BannerModel>('TopbannerBox');
    await Hive.openBox<BannerModel>('MiddlebannerBox');
    await Hive.openBox<BannerModel>('BottombannerBox');
    // await Hive.openBox<RecentlyVisitedModel>('getRecentProducts');
    await Hive.openBox<CategoryModel>('getCategoryProducts');
    await Hive.openBox<CategoryModel>('getCategory');
  }

  // GetHomeProduct methods
  static Future<void> saveGetHomeProductToHive(List<HomePageProducts> data) async {
    final box = Hive.box<HomePageProducts>('getHomeProducts');
    await box.clear();
    await box.addAll(data);
  }

  static Future<List<HomePageProducts>> getGetHomeProductFromHive() async {
    final box = Hive.box<HomePageProducts>('getHomeProducts');
    return box.values.toList();
  }

  // Banner methods
  static Future<void> saveBannerDataToHive(String position, List<BannerModel> bannerList) async {
    final box = Hive.box<BannerModel>('${position}bannerBox');
    await box.clear();
    await box.addAll(bannerList);
  }

  static Future<List<BannerModel>> getBannerDataFromHive(String position) async {
    final box = Hive.box<BannerModel>('${position}bannerBox');
    return box.values.toList();
  }

  // Recently visited methods
  // static Future<void> saveRecentlyVisited(List<RecentlyVisitedModel> data) async {
  //   final box = Hive.box<RecentlyVisitedModel>('getRecentProducts');
  //   await box.clear();
  //   await box.addAll(data);
  // }
  //
  // static Future<List<RecentlyVisitedModel>> getRecentlyVisited() async {
  //   final box = Hive.box<RecentlyVisitedModel>('getRecentProducts');
  //   return box.values.toList();
  // }

  // Category methods
  static Future<void> saveCategory(List<CategoryModel> data, {bool isMainCategory = false}) async {
    final boxName = isMainCategory ? 'getCategory' : 'getCategoryProducts';
    final box = Hive.box<CategoryModel>(boxName);
    await box.clear();
    await box.addAll(data);
  }

  static Future<List<CategoryModel>> getCategory({bool isMainCategory = false}) async {
    final boxName = isMainCategory ? 'getCategory' : 'getCategoryProducts';
    final box = Hive.box<CategoryModel>(boxName);
    return box.values.toList();
  }

  // Generic methods
  static Future<void> saveData<T>(String boxName, List<T> data) async {
    final box = await Hive.openBox<T>(boxName);
    await box.clear();
    await box.addAll(data);
  }

  static Future<List<T>> getData<T>(String boxName) async {
    final box = await Hive.openBox<T>(boxName);
    return box.values.toList();
  }

  static Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }
}