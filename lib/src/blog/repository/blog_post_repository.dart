import 'package:blog_common/blog_common.dart';

/// Repository for BlogPost
abstract class BlogPostRepository {
  /// Get all blog posts
  Future<List<BlogPost>> getAll();
}
