/// Centralizes the creation and provision of all repositories used in the application.
///
/// This class serves as a single point of configuration for all repository dependencies,
/// making them available throughout the application via the Provider pattern.
///
/// The [RepositoryProviders] class:
/// * Creates and configures all repository instances
/// * Injects dependencies like [RemoteConfig] into repositories that need them
/// * Makes repositories accessible to the widget tree through [MultiRepositoryProvider]
///
/// Example usage in your app:
/// ```dart
/// void main() {
///   runApp(
///     RepositoryProviders.multiRepositoryProvider(
///       remoteConfig: remoteConfig,
///       context: context,
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// To access a repository anywhere in the widget tree:
/// ```dart
/// final jsonRepo = context.read<JsonPlaceholderRepository>();
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_api_display/core/providers/multi_repository_provider.dart';
import 'package:flutter_api_display/core/providers/repository_provider.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repositories/json_placeholder_repository.dart';

class RepositoryProviders {
  /// Creates a [MultiRepositoryProvider] that provides all repositories to the application.
  ///
  /// Parameters:
  /// * [child] - The widget that will have access to all repositories
  /// * [remoteConfig] - Configuration instance that can be injected into repositories
  /// * [context] - The build context, used for provider creation
  ///
  /// Returns a [MultiRepositoryProvider] that should be placed high in the widget tree,
  /// typically at the root of the application.
  static MultiRepositoryProvider multiRepositoryProvider({
    required Widget child,
    required RemoteConfig remoteConfig,
    required BuildContext context,
  }) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => JsonPlaceholderRepository(
            remoteConfig: remoteConfig,
          ),
        )
      ],
      child: child,
    );
  }
}
