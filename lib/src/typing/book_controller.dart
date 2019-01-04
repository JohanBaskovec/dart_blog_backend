import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/typing/text_repository.dart';
import 'package:blog_common/blog_common.dart';

class BookController extends Controller {

  @override
  Future<void> post(RoutingContext routingContext) async {
    final TextRepository textRepository = await routingContext.textRepository;
    final Book book = await routingContext.getBodyAsObject(Book.fromJson);
    // TODO: input validation
    for (Text paragraph in book.paragraphs) {
      await textRepository.persist(paragraph);
    }

  }
}