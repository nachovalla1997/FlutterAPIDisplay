/// Error message templates
class ApiErrors {
  static String fetchPostFailed(int statusCode) =>
      'Failed to fetch post. Status code: $statusCode';

  static String fetchPostError(String error) => 'Error fetching post: $error';

  static String fetchPostsFailed(int statusCode) =>
      'Failed to fetch posts. Status code: $statusCode';

  static String fetchPostsError(String error) => 'Error fetching posts: $error';
}
