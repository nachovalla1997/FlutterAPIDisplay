import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/presentation/widgets/post_cart.dart';

class PostListView extends StatelessWidget {
  final PostProvider provider;

  const PostListView({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final state = provider.state;

    return ListView.builder(
      controller: _scrollController(provider),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: state.posts.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
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

        final post = state.posts[index];
        return PostCard(post: post);
      },
    );
  }

  ScrollController _scrollController(PostProvider provider) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (_shouldFetchMore(provider, controller)) {
        provider.fetchPosts();
      }
    });
    return controller;
  }

  bool _shouldFetchMore(PostProvider provider, ScrollController controller) {
    // TODO: Fetch on the middle of the screen
    return !provider.isSearching &&
        controller.position.pixels == controller.position.maxScrollExtent;
  }
}
