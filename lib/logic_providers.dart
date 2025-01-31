import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repositories/json_placeholder_repository.dart';
import 'package:provider/provider.dart';

/// Centralizes the creation and provision of all business logic providers (ViewModels)
/// used in the application.
///
/// The [LogicProviders] class:
/// * Creates and configures all ViewModel instances
/// * Injects repository dependencies into ViewModels that need them
/// * Makes ViewModels accessible to the widget tree through [MultiProvider]
///
/// Example usage in the app:
/// ```dart
/// void main() {
///   runApp(
///     RepositoryProviders.multiRepositoryProvider(
///       child: LogicProviders.multiLogicProvider(
///         remoteConfig: remoteConfig,
///         context: context,
///         child: MyApp(),
///       ),
///     ),
///   );
/// }
/// ```
///
/// To access a ViewModel anywhere in the widget tree:
/// ```dart
/// final postProvider = context.read<PostProvider>();
/// ```
class LogicProviders {
  /// Creates a [MultiProvider] that provides all ViewModels to the application.
  ///
  /// Parameters:
  /// * [child] - The widget that will have access to all ViewModels
  /// * [remoteConfig] - Configuration instance that can be injected into ViewModels
  /// * [context] - The build context, used for accessing repositories
  ///
  /// Returns a [MultiProvider] that should be placed after [RepositoryProviders]
  /// in the widget tree.
  static MultiProvider multiLogicProvider({
    required Widget child,
    required RemoteConfig remoteConfig,
    required BuildContext context,
  }) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PostProvider>(
            create: (context) => PostProvider(
              postRepository: context.read<JsonPlaceholderRepository>(),
            ),
          )
        ],
        child: child,
      );
}
