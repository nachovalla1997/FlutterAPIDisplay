import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/presentation/widgets/post_cart.dart';

/// A widget that displays a scrollable list of posts with pull-to-refresh
/// and infinite scrolling capabilities.
///
/// This widget handles:
/// - Displaying posts in a scrollable list
/// - Pull-to-refresh functionality
/// - Infinite scrolling with loading indicators
/// - Empty state handling
///
/// It works in conjunction with [PostProvider] to manage data fetching
/// and state updates.
class PostListView extends StatelessWidget {
  /// The provider that manages the posts data and loading states.
  ///
  /// This provider is responsible for:
  /// - Fetching posts
  /// - Managing pagination
  /// - Handling refresh operations
  /// - Tracking loading states
  final PostProvider provider;

  /// Creates a [PostListView] instance.
  ///
  /// Requires a [provider] to manage the posts data and state.
  const PostListView({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final state = provider.state;

    return RefreshIndicator(
      onRefresh: () => provider.fetchPosts(isRefresh: true),
      child: ListView.builder(
        controller: _scrollController(provider),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: state.posts.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end if more posts are available
          if (index == state.posts.length) {
            if (!provider.isSearching && state.hasMore) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          // Display post card for each post
          final post = state.posts[index];
          return PostCard(post: post);
        },
      ),
    );
  }

  /// Creates and configures a [ScrollController] for infinite scrolling.
  ///
  /// The controller listens for scroll events and triggers loading more posts
  /// when the user reaches the end of the list.
  ///
  /// Returns a configured [ScrollController] instance.
  ScrollController _scrollController(PostProvider provider) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (_shouldFetchMore(provider, controller)) {
        provider.fetchPosts();
      }
    });
    return controller;
  }

  /// Determines whether more posts should be fetched based on scroll position.
  ///
  /// Returns true if:
  /// - The user is not currently searching
  /// - The scroll position is at the maximum extent (bottom of the list)
  ///
  /// Parameters:
  /// * [provider] - The post provider to check search state
  /// * [controller] - The scroll controller to check position
  bool _shouldFetchMore(PostProvider provider, ScrollController controller) {
    // TODO: Fetch on the middle of the screen
    return !provider.isSearching &&
        controller.position.pixels == controller.position.maxScrollExtent;
  }
}
