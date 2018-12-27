import 'package:blog_backend/src/blog/controller/blog_posts_controller.dart';
import 'package:blog_common/blog_common.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  BlogPostsController controller;
  MockRoutingContext routingContext;
  MockBlogPostRepository blogPostRepository;

  setUp(() {
    controller = BlogPostsController();
    routingContext = MockRoutingContext();
    blogPostRepository = MockBlogPostRepository();
    when(routingContext.blogPostRepository).thenAnswer((_) async => blogPostRepository);
  });

  group('get', () {
    test('should return all blog posts', () async {
      final List<BlogPost> blogPosts = [
        BlogPost(title: 'title1', content: 'content1'),
        BlogPost(title: 'title2', content: 'content2')
      ];
      when(blogPostRepository.getAll()).thenAnswer((_) async => blogPosts);
      await controller.get(routingContext);
      verify(routingContext.okJsonResponse(blogPosts));
    });
  });
}
