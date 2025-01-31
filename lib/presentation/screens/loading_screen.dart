import 'package:flutter/material.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:lottie/lottie.dart';

/// A widget that displays a loading animation with an optional message.
///
/// This widget can show:
/// - A Lottie animation that can optionally pulse
/// - An optional message below the animation
/// - Customizable animation size and path
///
/// The pulsing effect is controlled by [enablePulse] and creates a subtle
/// scaling animation that repeats continuously.
class LoadingScreen extends StatefulWidget {
  /// Optional message to display below the loading animation
  final String? message;

  /// Path to the Lottie animation file
  final String animationPath;

  /// Size of the animation in logical pixels
  final double animationSize;

  /// Whether to enable the pulsing animation effect
  final bool enablePulse;

  /// Creates a loading screen with customizable properties.
  ///
  /// Parameters:
  /// * [message] - Optional text to display below the animation
  /// * [animationPath] - Path to the Lottie animation file (defaults to loading animation)
  /// * [animationSize] - Size of the animation (defaults to 200)
  /// * [enablePulse] - Whether to enable the pulsing effect (defaults to true)
  const LoadingScreen({
    super.key,
    this.message,
    this.animationPath = Configuration.kPathToLoadingAnimation,
    this.animationSize = 200,
    this.enablePulse = true,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  /// Controller for the pulsing animation
  late AnimationController _animationController;

  /// Animation that controls the scaling effect
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  /// Sets up the pulsing animation if enabled
  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation only if pulsing is enabled
    if (widget.enablePulse) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.enablePulse)
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildLottieAnimation(),
                );
              },
            )
          else
            _buildLottieAnimation(),
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the Lottie animation widget with the specified properties
  Widget _buildLottieAnimation() {
    return Lottie.asset(
      widget.animationPath,
      width: widget.animationSize,
    );
  }
}
