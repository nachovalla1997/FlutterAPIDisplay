import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_provider.dart';

/// A widget that provides a search interface for filtering posts.
///
/// This widget creates a styled search bar with:
/// - A search icon prefix
/// - A clear button suffix (when text is present)
/// - Real-time search functionality
/// - Elevated appearance with shadow
/// - Themed color integration
///
/// It works in conjunction with [PostProvider] to handle search operations
/// and maintain search state.
class PostSearchBar extends StatelessWidget {
  /// Controller for managing the search input text.
  ///
  /// This controller allows external widgets to:
  /// - Read the current search text
  /// - Clear the search field
  /// - Listen to text changes
  final TextEditingController controller;

  /// Provider that manages the post data and search operations.
  ///
  /// The provider is responsible for:
  /// - Handling search queries
  /// - Filtering posts based on search text
  /// - Managing search-related state
  final PostProvider provider;

  /// Creates a [PostSearchBar] instance.
  ///
  /// Both [controller] and [provider] are required to manage the search
  /// functionality and state.
  const PostSearchBar({
    super.key,
    required this.controller,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 8,
      ),
      child: TextField(
        controller: controller,
        onChanged: provider.searchPosts,
        decoration: InputDecoration(
          hintText: 'Search posts...',
          prefixIcon: const Icon(Icons.search),
          // Show clear button only when there's text
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    provider.searchPosts('');
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          // Normal border state
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          // Enabled border state
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          // Focused border state
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
