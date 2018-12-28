import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

void main() {
  PostgreSQLConnection connection;
  BlogPostRepository repository;

  setUpAll(() async {
    connection = PostgreSQLConnection('localhost', 5432, 'postgres',
        username: 'postgres', password: 'c4ef37c0fbd747da1c63c0f87d7c62df');
    await connection.open();
    repository = BlogPostRepository(connection);
  });

  group('getAll', () {
    test('should return all BlogPosts', () async {
      await connection.query('''delete from blog_post''');
      await connection.query('''insert into blog_post (title, content) 
    values 
    ('title1', 'content1'),
    ('title2', 'content2'),
    ('title3', 'content3')''');
      final List<BlogPost> blogPosts = await repository.getAll();
      expect(blogPosts.length, equals(3));
      expect(blogPosts[0].title, equals('title1'));
      expect(blogPosts[0].content, equals('content1'));
      expect(blogPosts[1].title, equals('title2'));
      expect(blogPosts[1].content, equals('content2'));
      expect(blogPosts[2].title, equals('title3'));
      expect(blogPosts[2].content, equals('content3'));
    });
  });
  group('persist', () {
    test('should insert new BlogPost', () async {
      await connection.query('''delete from blog_post''');
      final blogPost = BlogPost(title: 'title0', content: 'content0');
      await repository.persist(blogPost);
      expect(blogPost.id, isNotNull);
      final List<Map<String, Map<String, dynamic>>> result = await connection
          .mappedResultsQuery('''select * from blog_post''');
      expect(result.length, equals(1));
      expect(result[0]['blog_post']['title'], equals('title0'));
      expect(result[0]['blog_post']['content'], equals('content0'));
    });
    test('should update existing BlogPost', () async {
      await connection.query('''delete from blog_post''');
      final List<List> insertResult = await connection.query(
          '''insert into blog_post (title, content) values ('title0', 'content0') returning id''');
      final blogPost = BlogPost(title: 'title1', content: 'content1', id: insertResult[0][0] as int);
      await repository.persist(blogPost);
      final List<Map<String, Map<String, dynamic>>> result = await connection
          .mappedResultsQuery('''select * from blog_post''');
      expect(result.length, equals(1));
      expect(result[0]['blog_post']['title'], equals('title1'));
      expect(result[0]['blog_post']['content'], equals('content1'));
    });
  });
}
