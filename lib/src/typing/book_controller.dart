import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_backend/src/typing/book_repository.dart';
import 'package:blog_common/blog_common.dart';

class BookController extends Controller {
  /// Saves a new book and all its paragraphs
  @override
  Future<void> post(RoutingContext routingContext) async {
    final BookRepository bookRepository = await routingContext.bookRepository;
    final Book book = await routingContext.getBodyAsObject(Book.fromJson);
    await bookRepository.persist(book);
    routingContext.okJsonResponse({'message': 'ok'});
  }
}