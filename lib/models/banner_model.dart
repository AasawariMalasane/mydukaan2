class BannerModel {
  final String bannerId;
  final String bannerImage;
  final String productId;

  BannerModel({
    required this.bannerId,
    required this.bannerImage,
    required this.productId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerId: json['bannerId'],
      bannerImage: json['bannerImage'],
      productId: json['productId'],
    );
  }
}
