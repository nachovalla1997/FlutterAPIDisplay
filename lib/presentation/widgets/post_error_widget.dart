import 'package:flutter/material.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:lottie/lottie.dart';

/// A widget that displays an error state with animation and retry functionality.
///
/// This widget creates a styled error display with:
/// - A circular error animation
/// - An "Oops!" header
/// - A custom error message
/// - A retry button with refresh icon
///
/// It's typically used when:
/// - API calls fail
/// - Network errors occur
/// - Data loading encounters an error
/// - Any other error state that allows for retry functionality
class PostErrorWidget extends StatelessWidget {
  /// The error message to display to the user.
  ///
  /// This should be a user-friendly message explaining what went wrong.
  final String errorMessage;

  /// Callback function to be executed when the retry button is pressed.
  ///
  /// This is typically used to retry the failed operation (e.g., reload data).
  final VoidCallback onRetry;

  /// Creates a [PostErrorWidget] instance.
  ///
  /// Both [errorMessage] and [onRetry] parameters are required to ensure
  /// the widget can properly display the error and handle retry attempts.
  const PostErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error animation container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.red[400],
                shape: BoxShape.circle,
              ),
              child: Lottie.asset(
                Configuration.kPathToErrorAnimation,
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(height: 24),
            // Error header
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 8),
            // Custom error message
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            // Retry button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 20,
              ),
              label: const Text('Try Again'),
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
