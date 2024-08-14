class ColorModel {
  final String headerColor;
  final String footerColor;
  final String sidebarColor;
  final String extraColor;
  final String wishListColor;
  final String fontColor;
  final String selectedOptionColor;

  ColorModel({
    required this.headerColor,
    required this.footerColor,
    required this.sidebarColor,
    required this.extraColor,
    required this.wishListColor,
    required this.fontColor,
    required this.selectedOptionColor,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      headerColor: json['headerColor'] as String,
      footerColor: json['footerColor'] as String,
      sidebarColor: json['sidebarColor'] as String,
      extraColor: json['extraColor'] as String,
      wishListColor: json['wishListColor'] as String,
      fontColor: json['FontColor'] as String,
      selectedOptionColor: json['selectedOptionColor'] as String,
    );
  }
}