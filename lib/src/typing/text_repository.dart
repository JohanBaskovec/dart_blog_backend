import 'dart:math';

import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';

/// Global text cache, all texts are immutable
/// so they can be cached in memory forever.
final List<Text> _textsCache = [];

class TextRepository {
  static const String tableName = 'typist_text';
  PostgreSQLConnection _connection;
  final Random _randomGenerator = Random.secure();

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
      texts.add(textFromRow(blogPostRow));
    }
    return texts;
  }

  /// Get one blog posts
  Future<Text> getOne(int id) async {
    if (_textsCache.length >= id + 1 && _textsCache[id] != null) {
      return _textsCache[id];
    } else {
      final List<Map<String, Map<String, dynamic>>> results =
      await _connection.mappedResultsQuery('''
      select title, content, id
      from typist_text
      where id=@id
    ''', substitutionValues: {'id': id});
      final Map<String, Map<String, dynamic>> row = results[0];
      final Map<String, dynamic> textRow = row['typist_text'];
      final Text text = textFromRow(textRow);
      if (_textsCache.length < id + 1) {
        _textsCache.length = id * 2;
      }
      _textsCache[id] = text;
      return text;
    }
  }

  Future<Text> getOneRandom() async {
    return _textsCache[_randomGenerator.nextInt(_textsCache.length)];
  }

  /// Loads all the text in memory.
  Future<void> initializeCache() async {
    final List<Text> texts = await getAll();
    _textsCache.addAll(texts);
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
      _textsCache.add(text);
    }
  }

  /// Creates a Text from a database row (map of row name to value)
  Text textFromRow(Map<String, dynamic> row) {
    final text = Text(
        row['title'] as String,
        row['content'] as String,
        row['id'] as int
    );
    return text;
  }
}
