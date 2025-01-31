import 'package:flutter/material.dart';

class PostDetailsScreen extends StatelessWidget {
  final postId;

  const PostDetailsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Details")),
      body: const Center(
        child: Text("Post Details Screen"),
      ),
    );
  }
}
