import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';

class UserRepository {
  static const String tableName = 'typist_user';
  PostgreSQLConnection _connection;

  UserRepository(this._connection);

  Future<void> persist(User user) async {
    if (user.id == null) {
      final List<List> queryResult = await _connection
          .query('''insert into $tableName(
              username,
              email,
              password
            )
            values(
              @username,
              @email,
              @password
            ) returning id''', substitutionValues: {
        'username': user.username,
        'email': user.email,
        'password': user.password
      });
      user.id = queryResult[0][0] as int;
    } else {
      await _connection.query(
          '''update $tableName set username=@username where id=@id''',
          substitutionValues: {'username': user.username, 'id': user.id});
    }
  }

  Future<User> findByUsername(String username) async {
    final List<Map<String, Map<String, dynamic>>> results =
        await _connection.mappedResultsQuery('''
      select id, username
      from $tableName
      where username=@username
    ''', substitutionValues: {'username': username});
    if (results.isEmpty) {
      return null;
    }
    final Map<String, Map<String, dynamic>> row = results[0];
    final Map<String, dynamic> userRow = row[tableName];
    return userFromRow(userRow);
  }

  User userFromRow(Map<String, dynamic> row) {
    final user = User(row['username'] as String, row['email'] as String,
        row['password'] as String, row['id'] as int);
    return user;
  }
}
