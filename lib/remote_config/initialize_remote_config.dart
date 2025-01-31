import 'memory_remote_config.dart';
import 'remote_config.dart';

abstract class InitializeRemoteConfig {
  Future<RemoteConfig> initialize();
}

/// Memory Initialization
class InitializeMemoryRemoteConfig implements InitializeRemoteConfig {
  @override
  Future<RemoteConfig> initialize() async {
    final remoteConfig = MemoryRemoteConfig();
    await remoteConfig.fetchAndActivate();
    return remoteConfig;
  }
}
