import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mydukaanapp2/config/app_config.dart';
import '../models/category_model.dart';
import '../utils/app_colors.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategoryTap;

  const CategoryList({
    Key? key,
    required this.categories,
    required this.onCategoryTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "Categories",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
       SizedBox(
              height: 100,
              width: MediaQuery.sizeOf(context).width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onCategoryTap(categories[index]),
                    child: Container(
                      width: 80,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            blurStyle: BlurStyle.outer,
                            color: AppColors.lightTextColor,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: AppConfig.baseUrl+categories[index].displayImage!,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0) ),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholderFadeInDuration: Duration(microseconds: 0,seconds: 0,milliseconds: 0,minutes: 0,hours: 0),
                            placeholder: (context, url) => Container(height: 50,width:80,),
                            errorWidget: (context, url, error) => Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0) ),
                                image: DecorationImage(
                                    image: AssetImage("assets/images/drawer/NoImage.jpg"), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              categories[index].categoryName!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Image.asset("assets/images/category.png",width:25,)
                        ],
                      ),
                    ),
                  );
                },
              ),
       ),
      ],
    );
  }
}