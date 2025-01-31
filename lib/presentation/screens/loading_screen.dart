import 'package:flutter/material.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(Configuration.kPathToLoadingAnimation, width: 200),
    );
  }
}
