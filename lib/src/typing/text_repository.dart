import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';

class TextRepository {
  PostgreSQLConnection _connection;

  /// Creates a new TextRepository
  TextRepository(this._connection);

  /// Get all blog posts
  Future<List<Text>> getAll() async {
    final List<Map<String, Map<String, dynamic>>> results =
    await _connection.mappedResultsQuery('''
      select title, content, id
      from typist_text
    ''');
    final List<Text> texts = [];
    for (final row in results) {
      final Map<String, dynamic> blogPostRow = row['typist_text'];
      texts.add(blogPostFromRow(blogPostRow));
    }
    return texts;
  }

  /// Get one blog posts
  Future<Text> getOne(int id) async {
    final List<Map<String, Map<String, dynamic>>> results =
    await _connection.mappedResultsQuery('''
      select title, content, id
      from typist_text
      where id=@id
    ''', substitutionValues: {'id': id});
    final Map<String, Map<String, dynamic>> row = results[0];
    final Map<String, dynamic> blogPostRow = row['typist_text'];
    return blogPostFromRow(blogPostRow);
  }

  /// Inserts a text in the database. Does nothing if the text already exists
  /// (texts are immutable because it modifying them would invalidate
  /// all typing result, if you want to modify a text you must copy it)
  Future<void> persist(Text text) async {
    if (text.id == null) {
      final List<List> queryResult = await _connection.query(
          '''insert into typist_text(title, content, book_id, index_in_book)
           values(@title, @content, @bookId, @indexInBook) returning id''',
          substitutionValues: {
            'title': text.title,
            'content': text.content,
            'bookId': text.book?.id,
            'indexInBook': text?.indexInBook
          });
      text.id = queryResult[0][0] as int;
    }
  }

  /// Creates a Text from a database row (map of row name to value)
  Text blogPostFromRow(Map<String, dynamic> row) {
    final text = Text(
        row['title'] as String,
        row['content'] as String,
        row['id'] as int
    );
    return text;
  }
}
