import 'dart:convert';

import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_backend/src/controller.dart';
import 'package:blog_backend/src/routing_context.dart';
import 'package:blog_common/blog_common.dart';

/// Controller that returns all blog posts
class GetBlogPostsController extends Controller {
  @override
  Future<void> run(RoutingContext routingContext) async {
    final BlogPostRepository blogPostRepository = routingContext.blogPostRepository;
    final JsonEncoder jsonEncoder = routingContext.jsonEncoder;
    final List<BlogPost> blogPosts = await blogPostRepository.getAll();
    final json = jsonEncoder.convert(blogPosts);
    routingContext.okResponse(json);
  }
}

