import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_common/blog_common.dart';

/// Controller for blog posts
class BlogPostsController extends Controller {
  @override
  Future<void> get(RoutingContext routingContext) async {
    final BlogPostRepository blogPostRepository = await routingContext.blogPostRepository;
    final List<BlogPost> blogPosts = await blogPostRepository.getAll();
    routingContext.okJsonResponse(blogPosts);
  }
}

