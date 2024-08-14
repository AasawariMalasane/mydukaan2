class LogoModel {
  final String logoImage;

  LogoModel({required this.logoImage});

  factory LogoModel.fromJson(Map<String, dynamic> json) {
    return LogoModel(
      logoImage: json['logoImage'] as String,
    );
  }
}