import 'package:flutter_api_display/core/base_exception.dart';
import 'package:flutter_api_display/models/post_model.dart';

/// Represents the state of the `PostProvider`.
///
/// This state class manages:
/// - A list of posts retrieved from the repository.
/// - A selected post when viewing post details.
/// - Loading states for both the full list and a single post.
/// - Error handling using `BaseException`.
/// - Pagination control (`hasMore` and `page`).
///
/// The state is **immutable**, and updates are handled through `copyWith()`.
class PostState {
  /// List of posts currently loaded.
  final List<Post> posts;

  /// The currently selected post when viewing details.
  final Post? selectedPost;

  /// Indicates whether the post list is being loaded.
  final bool isLoading;

  /// Indicates whether a single post is being loaded.
  final bool isPostLoading;

  /// Holds any error encountered while fetching posts.
  final BaseException? error;

  /// Determines if more posts are available for pagination.
  final bool hasMore;

  /// The current page number for pagination.
  final int page;

  /// Creates a new immutable instance of `PostState`.
  ///
  /// - [posts] holds the current list of posts.
  /// - [selectedPost] stores the currently selected post, if any.
  /// - [isLoading] tracks whether the post list is loading.
  /// - [isPostLoading] tracks whether a single post is loading.
  /// - [error] stores any encountered exceptions.
  /// - [hasMore] indicates whether more posts are available for pagination.
  /// - [page] stores the current page number for paginated requests.
  PostState({
    required this.posts,
    required this.selectedPost,
    required this.isLoading,
    required this.isPostLoading,
    required this.error,
    required this.hasMore,
    required this.page,
  });

  /// Returns the initial state with default values.
  factory PostState.initial() {
    return PostState(
      posts: [],
      selectedPost: null,
      isLoading: false,
      isPostLoading: false,
      error: null,
      hasMore: true,
      page: 1,
    );
  }

  /// Creates a copy of the current state with optional new values.
  ///
  /// This ensures **immutability**, allowing controlled state updates.
  ///
  /// Example usage:
  /// ```dart
  /// state = state.copyWith(isLoading: true);
  /// ```
  ///
  /// - Any field that is not provided retains its current value.
  PostState copyWith({
    List<Post>? posts,
    Post? selectedPost,
    bool? isLoading,
    bool? isPostLoading,
    BaseException? error,
    bool? hasMore,
    int? page,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      selectedPost: selectedPost ?? this.selectedPost,
      isLoading: isLoading ?? this.isLoading,
      isPostLoading: isPostLoading ?? this.isPostLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
