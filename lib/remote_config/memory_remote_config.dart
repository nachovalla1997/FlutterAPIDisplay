import 'remote_config.dart';

class MemoryRemoteConfig implements RemoteConfig {
  final Map<String, dynamic> _configValues = {
    RemoteConfig.featureFlag: false,
    RemoteConfig.apiBaseUrl: ' https://jsonplaceholder.typicode.com',
  };

  @override
  Future<void> fetchAndActivate() async {
    // No fetching needed, values are hardcoded in memory.
  }

  @override
  String getString(String key) => _configValues[key]?.toString() ?? '';

  @override
  int getInt(String key) => _configValues[key] ?? 0;

  @override
  bool getBool(String key) => _configValues[key] ?? false;
}
