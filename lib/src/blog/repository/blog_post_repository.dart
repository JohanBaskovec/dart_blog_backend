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

  /// Persists a blog post in the database. If [blogPost]'id isn't null,
  /// inserts a new row, otherwise update existing row.
  Future<void> persist(BlogPost blogPost) async {
    if (blogPost.id == null) {
      final List<List> queryResult = await _connection.query(
          '''insert into blog_post(title, content) values(@title, @content) returning id''',
          substitutionValues: {'title': blogPost.title, 'content': blogPost.content});
      blogPost.id = queryResult[0][0] as int;
    } else {
      await _connection
          .query('''update blog_post set title=@title, content=@content where id=@id''',
              substitutionValues: {
            'title': blogPost.title,
            'content': blogPost.content,
            'id': blogPost.id
          });
    }
  }
}
