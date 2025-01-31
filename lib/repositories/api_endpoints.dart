/// API endpoint configurations
class ApiEndpoints {
  static String getPostDetails(String id) => '/posts/$id';
  static String getPostsList(int start, int limit) =>
      '/posts?_start=$start&_limit=$limit';
}
