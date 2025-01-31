/// **RemoteConfig Interface**
///
/// An abstract class representing a **Remote Configuration Service** for managing
/// application-level configurations and feature flags.
///
/// ### Responsibilities:
/// - Fetching remote configuration settings.
/// - Activating fetched configurations.
/// - Retrieving configuration values dynamically (`String`, `int`, `bool`).
/// - Providing static keys for frequently accessed configuration values.
///
abstract class RemoteConfig {
  /// **fetchAndActivate**
  ///
  /// Fetches the latest remote configuration values and
  /// activates them, making them available for immediate use.
  ///
  /// This method is typically called during **app startup** or when the user
  /// triggers a refresh of remote configurations.
  ///
  /// ### Returns:
  /// - A `Future<void>` that completes once fetching and activation are done.
  ///
  /// ### Example:
  /// ```dart
  /// await remoteConfig.fetchAndActivate();
  /// ```
  Future<void> fetchAndActivate();

  /// **getString**
  ///
  /// Retrieves a **String** value associated with the given configuration key.
  ///
  /// If the key does not exist or the value is not a `String`, a default value
  /// (defined by the specific implementation) may be returned.
  ///
  /// ### Parameters:
  /// - [key]: The key used to identify the configuration value.
  ///
  /// ### Returns:
  /// - A `String` representing the value of the configuration key.
  ///
  /// ### Example:
  /// ```dart
  /// final apiUrl = remoteConfig.getString(RemoteConfig.apiBaseUrl);
  /// ```
  String getString(String key);

  /// **getInt**
  ///
  /// Retrieves an **Integer** value associated with the given configuration key.
  ///
  /// If the key does not exist or the value is not an `int`, a default value
  /// (defined by the specific implementation) may be returned.
  ///
  /// ### Parameters:
  /// - [key]: The key used to identify the configuration value.
  ///
  /// ### Returns:
  /// - An `int` representing the value of the configuration key.
  ///
  /// ### Example:
  /// ```dart
  /// final retryCount = remoteConfig.getInt('RemoteConfig.maxRetryAttempts');
  /// ```
  int getInt(String key);

  /// **getBool**
  ///
  /// Retrieves a **Boolean** value associated with the given configuration key.
  ///
  /// If the key does not exist or the value is not a `bool`, a default value
  /// (defined by the specific implementation) may be returned.
  ///
  /// ### Parameters:
  /// - [key]: The key used to identify the configuration value.
  ///
  /// ### Returns:
  /// - A `bool` representing the value of the configuration key.
  ///
  /// ### Example:
  /// ```dart
  /// final isFeatureEnabled = remoteConfig.getBool(RemoteConfig.featureFlag);
  /// ```
  bool getBool(String key);

  // ----------------------------
  // Static Constants for Keys
  // ----------------------------

  /// **featureFlag**
  ///
  /// Key used to **enable or disable features dynamically** in the application.
  ///
  /// This is commonly used for **Feature Toggles** or **A/B testing** scenarios.
  ///
  /// ### Example:
  /// ```dart
  /// final isFeatureEnabled = remoteConfig.getBool(RemoteConfig.featureFlag);
  /// if (isFeatureEnabled) {
  ///   enableNewFeature();
  /// }
  /// ```
  static const String featureFlag = 'feature_flag';

  /// **apiBaseUrl**
  ///
  /// Key used to retrieve the **Base URL for the API** from the remote configuration.
  ///
  /// This allows dynamic switching of API endpoints without requiring an app release.
  ///
  /// ### Example:
  /// ```dart
  /// final baseUrl = remoteConfig.getString(RemoteConfig.apiBaseUrl);
  /// ```
  static const String apiBaseUrl = 'api_base_url';
}
