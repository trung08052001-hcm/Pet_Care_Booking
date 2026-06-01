import 'package:app/core/common/typedefs.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';

abstract interface class BlogRepository {
  ResultFuture<BlogPageContent> getBlogPageContent();
}
