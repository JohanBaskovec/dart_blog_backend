import 'package:blog_backend/src/blog/controller/get_blog_posts_controller.dart';
import 'package:blog_common/blog_common.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  group('get', () {
    test('should return all blog posts', () async {
      final controller = GetBlogPostsController();
      final routingContext = MockRoutingContext();
      final blogPostRepository = MockBlogPostRepository();
      final List<BlogPost> blogPosts = [
        BlogPost(title: 'title1', content: 'content1'),
        BlogPost(title: 'title2', content: 'content2')
      ];
      final jsonEncoder = MockJsonEncoder();
      const json = '[{"title": "title1", "content": "content1"}, '
          '{"title": "title2", "content": "content2"}]';
      when(jsonEncoder.convert(blogPosts)).thenReturn(json);
      when(routingContext.jsonEncoder).thenReturn(jsonEncoder);
      when(blogPostRepository.getAll()).thenAnswer((_) async => blogPosts);
      when(routingContext.blogPostRepository).thenReturn(blogPostRepository);
      await controller.get(routingContext);
      verify(routingContext.okResponse(json));
    });
  });
}