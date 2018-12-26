import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';

/// Controller that returns all blog posts
class GetBlogPostsController extends Controller {
  @override
  Future<void> run(RoutingContext routingContext) async {
    routingContext.setJsonContentType();
    routingContext.okResponse('ok');
  }
}

