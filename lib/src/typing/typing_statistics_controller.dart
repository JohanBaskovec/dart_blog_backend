import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/user/user_repository.dart';
import 'package:blog_common/blog_common.dart';
import 'package:postgres/postgres.dart';

class TypingStatisticsController extends Controller {
  @override
  String get path => '^/typing-statistics';

  @override
  Future<void> post(RoutingContext routingContext) async {
    final TypingStatistics stats = await routingContext.getBodyAsObject(
        TypingStatistics.fromJson);
    final UserRepository userRepository = await routingContext.userRepository;

    final User user = await userRepository.findByUsername('admin');
    // TODO: get current user
    // TODO: maybe split into repository...
    // TODO: save word and char wpm
    final PostgreSQLConnection connection = await routingContext.sqlConnection;
    await connection.query('''
      insert into text_wpm(wpm, text_id, user_id)
      values(@wpm, @textId, @userId)
    ''', substitutionValues: {
      'wpm': stats.wpm,
      'textId': stats.textId,
      'userId': user.id
    });

    routingContext.createdResponse();
  }
}