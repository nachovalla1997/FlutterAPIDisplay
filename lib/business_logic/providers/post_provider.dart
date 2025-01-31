import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/models/pure_manufacture/get_post_filter.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';
import 'package:flutter_api_display/utilities/configuration.dart';

/// A ChangeNotifier that manages the state and business logic for posts.
///
/// This provider acts as a ViewModel in the MVVM architecture, mediating between
/// the UI layer and the post repository.
class PostProvider extends ChangeNotifier {
  final IPostRepository _postRepository;
  PostState _state = PostState.initial();
  PostState get state => _state;

  PostProvider({required IPostRepository postRepository})
      : _postRepository = postRepository;

  /// Filters posts based on the search query
  ///
  /// If the query is empty, it shows all posts
  /// Otherwise, filters posts by title (case-insensitive)
  void searchPosts(String query) {
    final filteredPosts = _filterPosts(query);
    _setState(
      _state.copyWith(
        posts: filteredPosts,
        searchQuery: query,
      ),
    );
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
    if (_state.isLoading || (!_state.hasMore && !isRefresh)) return;

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
    _setState(
        state.copyWith(isPostLoading: true, error: null, selectedPost: null));

    final result = await _postRepository.getPost(
      GetPostFilter(id: id),
    );

    if (result.isSuccess()) {
      _setState(state.copyWith(
          selectedPost: result.tryGetSuccess(), isPostLoading: false));
    } else {
      _setState(
          state.copyWith(isPostLoading: false, error: result.tryGetError()));
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
      return postsToFilter;
    }

    return postsToFilter
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Updates the state and notifies listeners
  void _setState(PostState newState) {
    _state = newState;
    notifyListeners();
  }

  bool get isSearching => _state.searchQuery.isNotEmpty;
}
