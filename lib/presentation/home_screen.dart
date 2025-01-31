import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/presentation/post_details_screen.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the fetchPosts call for after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        if (state.isLoading && state.posts.isEmpty) {
          return Center(
              child: Lottie.asset(Configuration.kPathToLoadingAnimation));
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Posts")),
          body: _buildBody(context, state, provider),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, PostState state, PostProvider provider) {
    if (state.error != null && state.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/error.json",
                width: 150, height: 150),
            const SizedBox(height: 10),
            Text(state.error!.message,
                style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: provider.fetchPosts,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController(context, provider),
      itemCount: state.posts.length +
          (state.hasMore ? 1 : 0), // Extra item for loading indicator
      itemBuilder: (context, index) {
        if (index == state.posts.length) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }

        final post = state.posts[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(post.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailsScreen(postId: post.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Scroll Controller to detect when the user scrolls to the bottom
  ScrollController _scrollController(
      BuildContext context, PostProvider provider) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        provider.fetchPosts(); // Load more posts when reaching the bottom
      }
    });
    return controller;
  }
}
