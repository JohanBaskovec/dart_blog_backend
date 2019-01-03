import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/typing/text_repository.dart';
import 'package:blog_common/blog_common.dart';

class TypingTextController extends Controller {
  @override
  Future<void> get(RoutingContext routingContext) async {
    final TextRepository textRepository = await routingContext.textRepository;
    final String idString = routingContext.requestedUri.queryParameters['id'];
    if (idString == null) {
      final List<Text> texts = await textRepository.getAll();
      routingContext.okJsonResponse(texts);
    } else {
      final id = int.parse(idString);
      if (id != null) {
        final Text text = await textRepository.getOne(id);
        routingContext.okJsonResponse(text);
      }
    }
  }

  @override
  Future<void> post(RoutingContext routingContext) async {
    // TODO: input validation
    final Text text = await routingContext.getBodyAsObject(Text.fromJson);
    final TextRepository textRepository = await routingContext.textRepository;
    await textRepository.persist(text);
    routingContext.okJsonResponse(text);
  }
}
