import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/models/pure_manufacture/get_post_filter.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';
import 'package:flutter_api_display/utilities/configuration.dart';
import 'package:flutter_api_display/utilities/logger.dart';

/// A ChangeNotifier that manages the state and business logic for posts.
///
/// This provider acts as a ViewModel in the MVVM architecture, mediating between
/// the UI layer and the post repository.
class PostProvider extends ChangeNotifier {
  final IPostRepository _postRepository;
  PostState _state = PostState.initial();
  PostState get state => _state;

  PostProvider({required IPostRepository postRepository})
      : _postRepository = postRepository {
    AppLogger.info(message: 'PostProvider initialized');
  }

  /// Filters posts based on the search query
  ///
  /// If the query is empty, it shows all posts
  /// Otherwise, filters posts by title (case-insensitive)
  void searchPosts(String query) {
    AppLogger.debug(message: 'Searching posts with query: "$query"');
    final filteredPosts = _filterPosts(query);
    _setState(
      _state.copyWith(
        posts: filteredPosts,
        searchQuery: query,
      ),
    );
    AppLogger.info(
        message: 'Search completed. Found ${filteredPosts.length} matches');
  }

  /// Fetches the next page of posts from the repository
  ///
  /// Handles loading state, pagination, and maintains search filtering
  /// Returns early if already loading or no more posts are available
  ///
  /// Parameters:
  /// * [isRefresh] - Indicates whether to refresh the list (default: false)
  ///
  Future<void> fetchPosts({bool isRefresh = false}) async {
    if (_state.isLoading || (!_state.hasMore && !isRefresh)) {
      AppLogger.debug(
          message: 'Fetch posts skipped: loading=${_state.isLoading}, '
              'hasMore=${_state.hasMore}, isRefresh=$isRefresh');
      return;
    }

    AppLogger.info(
        message: '${isRefresh ? 'Refreshing' : 'Fetching'} posts - '
            'Page: ${isRefresh ? 1 : _state.page}');

    _setState(_state.copyWith(
      isLoading: true,
      page: isRefresh ? 1 : _state.page,
      hasMore: isRefresh ? true : _state.hasMore,
    ));

    final result = await _postRepository.getPosts(
      limit: Configuration.kPostsPerPage,
      page: isRefresh ? 1 : _state.page,
    );

    if (result.isSuccess()) {
      final newPosts = result.tryGetSuccess();
      if (newPosts != null) {
        final allPosts = isRefresh ? newPosts : [..._state.posts, ...newPosts];

        AppLogger.info(
            message: 'Successfully ${isRefresh ? 'refreshed' : 'fetched'} '
                '${newPosts.length} posts. Total: ${allPosts.length}');

        _setState(_state.copyWith(
          posts: allPosts,
          backUpPosts: allPosts,
          isLoading: false,
          hasMore: newPosts.isNotEmpty,
          page: isRefresh ? 2 : _state.page + 1,
          error: null,
        ));
      }
    } else {
      final error = result.tryGetError();
      AppLogger.error(
        message: 'Failed to fetch posts',
        error: error,
      );

      _setState(_state.copyWith(
        isLoading: false,
        error: error,
        hasMore: isRefresh ? true : _state.hasMore,
      ));
    }
  }

  /// Fetches a single post by its ID.
  ///
  /// - Sets `isPostLoading` to true while loading.
  /// - Updates `selectedPost` once loaded.
  /// - Handles errors if fetching fails.
  Future<void> fetchPostById(String id) async {
    AppLogger.info(message: 'Fetching post details for ID: $id');

    _setState(
        state.copyWith(isPostLoading: true, error: null, selectedPost: null));

    final result = await _postRepository.getPost(
      GetPostFilter(id: id),
    );

    if (result.isSuccess()) {
      final post = result.tryGetSuccess();
      AppLogger.info(message: 'Successfully fetched post details for ID: $id');
      _setState(state.copyWith(selectedPost: post, isPostLoading: false));
    } else {
      final error = result.tryGetError();
      AppLogger.error(
        message: 'Failed to fetch post details for ID: $id',
        error: error,
      );
      _setState(state.copyWith(isPostLoading: false, error: error));
    }
  }

  /// Filters posts based on a search query
  ///
  /// Parameters:
  /// * [query] - The search term to filter by
  /// * [posts] - Optional list of posts to filter (defaults to current state posts)
  ///
  /// Returns the filtered list of posts
  List<Post> _filterPosts(String query, {List<Post>? posts}) {
    final postsToFilter = posts ?? _state.backUpPosts;
    if (query.trim().isEmpty) {
      AppLogger.debug(message: 'Filter cleared, showing all posts');
      return postsToFilter;
    }

    final lowerCaseQuery = query.toLowerCase();
    final filteredPosts = postsToFilter
        .where((post) => post.title.toLowerCase().contains(lowerCaseQuery))
        .toList();

    AppLogger.debug(
        message: 'Filtered posts by query "$query". '
            'Found ${filteredPosts.length} matches');
    return filteredPosts;
  }

  /// Updates the state and notifies listeners
  void _setState(PostState newState) {
    _state = newState;
    notifyListeners();
  }

  bool get isSearching => _state.searchQuery.isNotEmpty;

  bool get isLoading => _state.isLoading;
}
