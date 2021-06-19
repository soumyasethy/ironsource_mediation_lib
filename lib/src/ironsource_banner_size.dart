/// Banner Size
class IronSourceBannerSize {
  final int width;
  final int height;
  late final String description;

// private constructor to prevent description - WH conflicts
  IronSourceBannerSize._({this.width = 0, this.height = 0, required this.description});

  static IronSourceBannerSize BANNER = IronSourceBannerSize._(description: "BANNER");
  static IronSourceBannerSize LARGE = IronSourceBannerSize._(description: "LARGE");
  static IronSourceBannerSize RECTANGLE = IronSourceBannerSize._(description: "RECTANGLE");
  static IronSourceBannerSize SMART = IronSourceBannerSize._(description: "SMART");

  static IronSourceBannerSize custom({required int width, required int height}) {
    return IronSourceBannerSize._(width: width, height: height, description: "CUSTOM");
  }
}
