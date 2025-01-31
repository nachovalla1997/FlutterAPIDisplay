import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/presentation/widgets/loading_widget.dart';
import 'package:flutter_api_display/presentation/widgets/post_error_widget.dart';
import 'package:flutter_api_display/presentation/widgets/post_info_widget.dart';
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
    return const LoadingWidget(
      animationSize: 300,
      enablePulse: false,
    );
  }

  /// Displays an error message with a retry button.
  Widget _buildError(BuildContext context, PostProvider provider) {
    return PostErrorWidget(
        errorMessage: provider.state.error!.message,
        onRetry: () {
          provider.fetchPostById(widget.postId);
        });
  }

  /// Shows a "Post Not Found" message if the post doesn't exist.
  Widget _buildNotFound() {
    return PostInfoWidget(
      message: "The post you are looking for was not found.",
      actionLabel: "Go Back",
      onAction: () => Navigator.pop(context),
    );
  }

  /// Displays the post details (title & body).
  Widget _buildPostDetails(PostState state) {
    final post = state.selectedPost!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              post.body ?? '',
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            // Add bottom padding to ensure content isn't cut off
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
