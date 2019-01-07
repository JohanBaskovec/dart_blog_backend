import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/typing/text_repository.dart';

class RandomTextController extends Controller {
  @override
  String get path => '^/random-text';

  @override
  Future<void> get(RoutingContext routingContext) async {
    final TextRepository textRepository = await routingContext.textRepository;
    routingContext.okJsonResponse(await textRepository.getOneRandom());
  }
}
