import 'package:flutter/material.dart';

/// A custom app bar widget that implements [PreferredSizeWidget].
///
/// This widget creates a gradient-styled app bar with:
/// - A centered title "Posts"
/// - A blue gradient background
/// - Custom elevation and styling
///
/// The app bar maintains a consistent height using [kToolbarHeight]
/// and implements [PreferredSizeWidget] to properly integrate with
/// Flutter's app bar system.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [CustomAppBar] instance.
  ///
  /// The app bar is designed with a fixed style and doesn't accept
  /// customization parameters to maintain design consistency across
  /// the application.
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Posts",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      elevation: 5,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF007AFF), // Light blue
              Color(0xFF0056D2), // Dark blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  /// The preferred size of the app bar.
  ///
  /// This getter is required by [PreferredSizeWidget] and returns
  /// a size with the standard [kToolbarHeight] to maintain
  /// consistency with Flutter's default app bar height.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
