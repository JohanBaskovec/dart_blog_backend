import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';

class BookRepository {
  PostgreSQLConnection _connection;

  /// Creates a new TextRepository
  BookRepository(this._connection);

  /// Get all books without their paragraphs.
  Future<List<Book>> getBookSummaries() async {
    final List<Map<String, Map<String, dynamic>>> results =
        await _connection.mappedResultsQuery('''
      select title, paragraph_count
      from book
    ''');
    final List<Book> books = [];
    for (final row in results) {
      final Map<String, dynamic> blogPostRow = row['book'];
      books.add(bookFromRow(blogPostRow));
    }
    return books;
  }

  /// Persists a book in the database. If [book]'id isn't null,
  /// inserts a new row, otherwise update existing row.
  Future<void> persist(Book book) async {
    if (book.id == null) {
      final List<List> queryResult =
          await _connection.query('''insert into book(title)
           values(@title) returning id''', substitutionValues: {
        'title': book.title,
      });
      book.id = queryResult[0][0] as int;
    } else {
      await _connection.query('''update book set title=@title id=@id''',
          substitutionValues: {'title': book.title, 'id': book.id});
    }
  }

  Book bookFromRow(Map<String, dynamic> row) {
    final book = Book.withoutParagraphs(row['title'] as String,
        row['paragraph_count'] as int, row['id'] as int);
    return book;
  }
}
