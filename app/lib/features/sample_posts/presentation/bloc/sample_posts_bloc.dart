import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/sample_posts/domain/entities/sample_post.dart';
import 'package:app/features/sample_posts/domain/usecases/get_sample_posts_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

sealed class SamplePostsEvent extends Equatable {
  const SamplePostsEvent();

  @override
  List<Object?> get props => const [];
}

final class SamplePostsRequested extends SamplePostsEvent {
  const SamplePostsRequested();
}

enum SamplePostsStatus {
  initial,
  loading,
  success,
  failure,
}

class SamplePostsState extends Equatable {
  const SamplePostsState({
    this.status = SamplePostsStatus.initial,
    this.posts = const [],
    this.message,
  });

  final SamplePostsStatus status;
  final List<SamplePost> posts;
  final String? message;

  SamplePostsState copyWith({
    SamplePostsStatus? status,
    List<SamplePost>? posts,
    String? message,
  }) {
    return SamplePostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        posts,
        message,
      ];
}

@injectable
class SamplePostsBloc extends Bloc<SamplePostsEvent, SamplePostsState> {
  SamplePostsBloc(this._getSamplePostsUseCase)
      : super(const SamplePostsState()) {
    on<SamplePostsRequested>(_onRequested);
  }

  final GetSamplePostsUseCase _getSamplePostsUseCase;

  Future<void> _onRequested(
    SamplePostsRequested event,
    Emitter<SamplePostsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SamplePostsStatus.loading,
        message: null,
      ),
    );

    final result = await _getSamplePostsUseCase(const NoParams());
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: SamplePostsStatus.failure,
            posts: const [],
            message: failure.message,
          ),
        );
      },
      (posts) {
        emit(
          state.copyWith(
            status: SamplePostsStatus.success,
            posts: posts,
            message: null,
          ),
        );
      },
    );
  }
}
