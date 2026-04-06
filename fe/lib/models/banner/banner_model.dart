class BannerModel {
  final String id;
  final String bannerCode;
  final String bannerName;
  final String? imageBanner;

  BannerModel({
    required this.id,
    required this.bannerCode,
    required this.bannerName,
    this.imageBanner,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] ?? '',
      bannerCode: json['bannerCode'] ?? '',
      bannerName: json['bannerName'] ?? '',
      imageBanner: json['imageBanner'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bannerCode': bannerCode,
      'bannerName': bannerName,
      'imageBanner': imageBanner,
    };
  }
}
