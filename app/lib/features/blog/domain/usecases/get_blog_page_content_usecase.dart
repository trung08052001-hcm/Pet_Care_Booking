import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';
import 'package:app/features/blog/domain/repositories/blog_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBlogPageContentUseCase implements UseCase<BlogPageContent, NoParams> {
  GetBlogPageContentUseCase(this._repository);

  final BlogRepository _repository;

  @override
  ResultFuture<BlogPageContent> call(NoParams params) {
    return _repository.getBlogPageContent();
  }
}
