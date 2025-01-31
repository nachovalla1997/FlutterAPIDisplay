import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/presentation/screens/loading_screen.dart';
import 'package:flutter_api_display/presentation/screens/post_details_screen.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        return Scaffold(
          appBar: !_isLoading(state)
              ? AppBar(
                  title: const Text(
                    "Posts",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  centerTitle: true,
                  elevation: 5,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF007AFF), Color(0xFF0056D2)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                )
              : null,
          bottomSheet: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: provider.searchPosts,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search posts...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            provider.searchPosts('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          body: _buildBody(context, state, provider),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, PostState state, PostProvider provider) {
    if (_isLoading(state)) {
      return LoadingScreen();
    }

    if (state.error != null && state.posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(Configuration.kPathToErrorAnimation, width: 180),
              const SizedBox(height: 10),
              Text(
                state.error!.message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: provider.fetchPosts,
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

    return ListView.builder(
      controller: _scrollController(context, provider),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: state.posts.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.posts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final post = state.posts[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailsScreen(postId: post.id)),
              );
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE3E3E3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text(
                    post.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isLoading(PostState state) => state.isLoading && state.posts.isEmpty;

  ScrollController _scrollController(
      BuildContext context, PostProvider provider) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        provider.fetchPosts();
      }
    });
    return controller;
  }
}
