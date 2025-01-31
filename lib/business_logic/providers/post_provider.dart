import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/models/post_model.dart';
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
    final filteredPosts =_filterPosts(query);
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
  Future<void> fetchPosts() async {
    if (_state.isLoading || !_state.hasMore) return;

    _setState(_state.copyWith(isLoading: true));

    final result = await _postRepository.getPosts(
      limit: Configuration.kPostsPerPage,
      page: _state.page,
    );

    if (result.isSuccess()) {
      final newPosts = result.tryGetSuccess();
      if (newPosts != null) {
        final allPosts = [..._state.posts, ...newPosts];

        _setState(_state.copyWith(
          posts: allPosts,
          backUpPosts: allPosts,
          isLoading: false,
          hasMore: newPosts.isNotEmpty,
          page: _state.page + 1,
          error: null,
        ));
      }
    } else {
      final error = result.tryGetError();

      _setState(_state.copyWith(
        isLoading: false,
        error: error,
      ));
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
}
