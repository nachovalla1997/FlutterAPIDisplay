import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/presentation/screens/loading_screen.dart';
import 'package:flutter_api_display/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_api_display/presentation/widgets/post_error_widget.dart';
import 'package:flutter_api_display/presentation/widgets/post_info_widget.dart';
import 'package:flutter_api_display/presentation/widgets/post_list_view.dart';
import 'package:flutter_api_display/presentation/widgets/post_search_bar.dart';
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

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: !_isLoading(state) ? const CustomAppBar() : null,
            body: Column(
              children: [
                Expanded(
                  child: _buildBody(state, provider),
                ),
                _shouldShowSearchBar(state)
                    ? PostSearchBar(
                        controller: _searchController,
                        provider: provider,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(PostState state, PostProvider provider) {
    if (_isLoading(state)) {
      return const LoadingScreen();
    }

    if (_shouldShowError(state)) {
      return PostErrorWidget(
        errorMessage: state.error!.message,
        onRetry: () => provider.fetchPosts(isRefresh: true),
      );
    }

    if (_shouldShowNoPostFound(state)) {
      return PostInfoWidget(
        message: 'No posts found for "${state.searchQuery}"',
        actionLabel: 'Clear Search',
        onAction: () => {
          provider.searchPosts(''),
          _searchController.clear(),
        },
      );
    }

    return PostListView(provider: provider);
  }

  bool _shouldShowNoPostFound(PostState state) =>
      state.posts.isEmpty && state.searchQuery.isNotEmpty;

  bool _shouldShowError(PostState state) =>
      state.error != null && state.posts.isEmpty;

  bool _shouldShowSearchBar(PostState state) =>
      !_isLoading(state) && state.error == null;

  bool _isLoading(PostState state) => state.isLoading && state.posts.isEmpty;
}
