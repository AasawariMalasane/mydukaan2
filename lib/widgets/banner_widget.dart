import 'package:flutter/material.dart';

import '../models/banner_model.dart';

class BannerWidget extends StatelessWidget {
  final List<BannerModel> banners;

  const BannerWidget({Key? key, required this.banners}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Image.network(
            banners[index].bannerImage,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
