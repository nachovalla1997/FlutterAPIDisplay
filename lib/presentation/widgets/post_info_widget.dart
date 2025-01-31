import 'package:flutter/material.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:lottie/lottie.dart';

/// A widget that displays informational messages with an animation and action button.
///
/// This widget creates a styled information display with:
/// - A customizable Lottie animation
/// - An informational message
/// - An action button with a refresh icon
///
/// It's typically used for:
/// - Empty state displays
/// - No search results found
/// - Success messages with follow-up actions
/// - Any informational state requiring user action
class PostInfoWidget extends StatelessWidget {
  /// The message to display to the user.
  ///
  /// This should be a clear, informative message explaining the current state
  /// or providing guidance to the user.
  final String message;

  /// The label text for the action button.
  ///
  /// This should be a short, action-oriented text that clearly indicates
  /// what will happen when pressed (e.g., "Clear Search", "Try Again").
  final String actionLabel;

  /// Callback function to be executed when the action button is pressed.
  ///
  /// This is typically used to trigger state changes or navigation.
  final VoidCallback onAction;

  /// The path to the Lottie animation file to be displayed.
  ///
  /// Defaults to [Configuration.kPathToNoDataFoundAnimation].
  /// Can be customized to show different animations for different states.
  final String animationPath;

  /// Creates a [PostInfoWidget] instance.
  ///
  /// Parameters:
  /// * [message] - Required. The informational message to display.
  /// * [actionLabel] - Required. The text for the action button.
  /// * [onAction] - Required. The callback for the action button.
  /// * [animationPath] - Optional. Defaults to no data found animation.
  const PostInfoWidget({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.animationPath = Configuration.kPathToNoDataFoundAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation
            Lottie.asset(
              animationPath,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            // Information message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            // Action button
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(actionLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size(140, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
