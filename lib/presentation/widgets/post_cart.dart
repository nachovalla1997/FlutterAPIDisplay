import 'package:flutter/material.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/presentation/screens/post_details_screen.dart';

/// A card widget that displays a post preview and handles navigation
/// to its details screen.
///
/// This widget creates a styled card with:
/// - A gradient background
/// - The post's title
/// - A forward arrow indicator
/// - Touch interaction with navigation
///
/// When tapped, it navigates to [PostDetailsScreen] with the selected post's ID.
class PostCard extends StatelessWidget {
  /// The post model containing the data to be displayed.
  final Post post;

  /// Creates a [PostCard] instance.
  ///
  /// Requires a [post] parameter containing the post data to be displayed.
  /// The [key] parameter is optional and is passed to the super class.
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: GestureDetector(
        onTap: () => _navigateToDetails(context),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFFE3E3E3), // Light grey
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              title: Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to the post details screen when the card is tapped.
  ///
  /// Uses [MaterialPageRoute] to create a platform-adaptive transition
  /// to the [PostDetailsScreen] with the current post's ID.
  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsScreen(postId: post.id),
      ),
    );
  }
}
