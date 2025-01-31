/// Configuration class to store all the configuration values.
class Configuration {
  /// The number of posts to fetch per page
  static const int kPostsPerPage = 10;

  /// The path to the loading animation asset
  static const String kPathToLoadingAnimation =
      "assets/animations/loading.json";

  static const String kPathToLoadingPostsAnimation =
      "assets/animations/loading_posts.json";

  /// The path to the error animation asset
  static const String kPathToErrorAnimation = "assets/animations/error.json";

  /// The path to the no data found animation asset
  static const String kPathToNoDataFoundAnimation =
      "assets/animations/no_data_found.json";
}
