import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_common/blog_common.dart';

/// Controller for blog posts
class BlogPostsController extends Controller {
  @override
  Future<void> get(RoutingContext routingContext) async {
    final BlogPostRepository blogPostRepository =
        await routingContext.blogPostRepository;
    final String idString = routingContext.requestedUri.queryParameters['id'];
    if (idString == null) {
      final List<BlogPost> blogPosts = await blogPostRepository.getAll();
      routingContext.okJsonResponse(blogPosts);
    } else {
      final id = int.parse(idString);
      if (id != null) {
        final BlogPost blogPost = await blogPostRepository.getOne(id);
        routingContext.okJsonResponse(blogPost);
      }
    }
  }

  @override
  Future<void> post(RoutingContext routingContext) async {
    // TODO: input validation
    final BlogPost blogPost =
        await routingContext.getBodyAsObject(BlogPost.fromJson);
    final BlogPostRepository blogPostRepository =
        await routingContext.blogPostRepository;
    await blogPostRepository.persist(blogPost);
    routingContext.okJsonResponse(blogPost);
  }
}
