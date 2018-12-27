import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';

/// Blog post repository.
class BlogPostRepository {
  PostgreSQLConnection _connection;

  /// Creates a new BlogPostRepositoryImpl
  BlogPostRepository(this._connection);

  /// Get all blog posts
  Future<List<BlogPost>> getAll() async {
    final List<Map<String, Map<String, dynamic>>> results =
    await _connection.mappedResultsQuery('''
      select title, content, id
      from blog_post
    ''');
    final List<BlogPost> blogPosts = [];
    for (final row in results) {
      final Map<String, dynamic> blogPostRow = row['blog_post'];
      blogPosts.add(BlogPost(
          title: blogPostRow['title'] as String,
          content: blogPostRow['content'] as String));
    }
    return blogPosts;
  }
}

