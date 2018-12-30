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
      blogPosts.add(blogPostFromRow(blogPostRow));
    }
    return blogPosts;
  }

  /// Get one blog posts
  Future<BlogPost> getOne(int id) async {
    final List<Map<String, Map<String, dynamic>>> results =
        await _connection.mappedResultsQuery('''
      select title, content, id
      from blog_post
      where id=@id
    ''', substitutionValues: {'id': id});
    final Map<String, Map<String, dynamic>> row = results[0];
    final Map<String, dynamic> blogPostRow = row['blog_post'];
    return blogPostFromRow(blogPostRow);
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

  BlogPost blogPostFromRow(Map<String, dynamic> row) {
    final blogPost = BlogPost(
        title: row['title'] as String,
        content: row['content'] as String,
        id: row['id'] as int
    );
    return blogPost;
  }
}
