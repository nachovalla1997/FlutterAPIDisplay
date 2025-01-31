import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PostDetailsScreen extends StatefulWidget {
  final String postId;

  const PostDetailsScreen({super.key, required this.postId});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postProvider = context.read<PostProvider>();

      /// Avoid fetching if the post is already loaded
      if (postProvider.state.selectedPost?.id.toString() != widget.postId) {
        postProvider.fetchPostById(widget.postId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        return Scaffold(
          appBar: AppBar(title: const Text("Post Details")),
          body: _buildBody(context, provider, state),
        );
      },
    );
  }

  /// Builds the UI based on different loading states.
  Widget _buildBody(
      BuildContext context, PostProvider provider, PostState state) {
    if (state.isPostLoading) {
      return _buildLoading();
    }

    if (state.error != null) {
      return _buildError(context, provider);
    }

    if (state.selectedPost == null) {
      return _buildNotFound();
    }

    return _buildPostDetails(state);
  }

  /// Shows a loading animation while fetching the post.
  Widget _buildLoading() {
    return Center(
      child: Lottie.asset(Configuration.kPathToLoadingAnimation, width: 150),
    );
  }

  /// Displays an error message with a retry button.
  Widget _buildError(BuildContext context, PostProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(Configuration.kPathToErrorAnimation, width: 180),
            const SizedBox(height: 10),
            Text(
              "Failed to load post",
              style: const TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => provider.fetchPostById(widget.postId),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a "Post Not Found" message if the post doesn't exist.
  Widget _buildNotFound() {
    return const Center(
      child: Text("Post not found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  /// Displays the post details (title & body).
  Widget _buildPostDetails(PostState state) {
    final post = state.selectedPost!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(post.body ?? '', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
