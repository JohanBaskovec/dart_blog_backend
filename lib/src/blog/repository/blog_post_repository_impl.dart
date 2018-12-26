import 'package:blog_backend/src/blog/repository/blog_post_repository.dart';
import 'package:blog_common/blog_common.dart';

///
class BlogPostRepositoryImpl implements BlogPostRepository {
  @override
  Future<List<BlogPost>> getAll() async {
    throw UnimplementedError();
  }
}