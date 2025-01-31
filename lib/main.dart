import 'package:flutter/material.dart';
import 'package:flutter_api_display/logic_providers.dart';
import 'package:flutter_api_display/presentation/application_theme.dart';
import 'package:flutter_api_display/presentation/home_screen.dart';
import 'package:flutter_api_display/remote_config/initialize_remote_config.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repository_providers.dart';
import 'package:flutter_api_display/utilities/logger.dart';

void main() async {
  AppLogger.info(message: 'Starting Flutter API Display App.');
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info(message: 'Initializing the Remote Config');
  InitializeRemoteConfig memoryConfig = InitializeMemoryRemoteConfig();
  RemoteConfig remoteConfig = await memoryConfig.initialize();

  AppLogger.info(message: 'Running the App');
  runApp(MyApp(
    remoteConfig: remoteConfig,
  ));
}

class MyApp extends StatelessWidget {
  final RemoteConfig remoteConfig;

  const MyApp({super.key, required this.remoteConfig});

  @override
  Widget build(BuildContext context) {
    return RepositoryProviders.multiRepositoryProvider(
      child: LogicProviders.multiLogicProvider(
        child: MaterialApp(
          title: 'Flutter API Display',
          home: const HomeScreen(),
          theme: ApplicationTheme.lightTheme,
          darkTheme: ApplicationTheme.darkTheme,
          themeMode: ThemeMode.system,
        ),
        context: context,
        remoteConfig: remoteConfig,
      ),
      remoteConfig: remoteConfig,
      context: context,
    );
  }
}
