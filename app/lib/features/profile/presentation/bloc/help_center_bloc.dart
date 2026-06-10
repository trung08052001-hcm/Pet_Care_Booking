import 'package:app/features/profile/domain/usecases/get_help_center_content_usecase.dart';
import 'package:app/features/profile/presentation/bloc/help_center_event.dart';
import 'package:app/features/profile/presentation/bloc/help_center_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpCenterBloc extends Bloc<HelpCenterEvent, HelpCenterState> {
  HelpCenterBloc(this._getHelpCenterContentUseCase)
      : super(const HelpCenterState()) {
    on<HelpCenterStarted>(_onStarted);
    on<HelpCenterSearchChanged>(_onSearchChanged);
    on<HelpCenterCategoryPressed>(_onCategoryPressed);
    on<HelpCenterFaqPressed>(_onFaqPressed);
    on<HelpCenterContactPressed>(_onContactPressed);
    on<HelpCenterRequestPressed>(_onRequestPressed);
    on<HelpCenterFeedbackConsumed>(_onFeedbackConsumed);
  }

  final GetHelpCenterContentUseCase _getHelpCenterContentUseCase;

  void _onStarted(
    HelpCenterStarted event,
    Emitter<HelpCenterState> emit,
  ) {
    emit(
      state.copyWith(
        status: HelpCenterStatus.loading,
        clearMessage: true,
        interaction: HelpCenterInteraction.none,
      ),
    );

    final content = _getHelpCenterContentUseCase();
    emit(
      state.copyWith(
        status: HelpCenterStatus.ready,
        content: content,
        filteredContent: content,
      ),
    );
  }

  void _onSearchChanged(
    HelpCenterSearchChanged event,
    Emitter<HelpCenterState> emit,
  ) {
    final content = state.content ?? _getHelpCenterContentUseCase();
    emit(
      state.copyWith(
        status: HelpCenterStatus.ready,
        content: content,
        filteredContent: content.filter(event.query),
        query: event.query,
        clearMessage: true,
        interaction: HelpCenterInteraction.none,
      ),
    );
  }

  void _onCategoryPressed(
    HelpCenterCategoryPressed event,
    Emitter<HelpCenterState> emit,
  ) {
    emit(
      state.copyWith(
        message: 'Danh mục này sẽ được mở rộng ở bước kết nối dữ liệu.',
        interaction: HelpCenterInteraction.category,
      ),
    );
  }

  void _onFaqPressed(
    HelpCenterFaqPressed event,
    Emitter<HelpCenterState> emit,
  ) {
    emit(
      state.copyWith(
        message: event.question,
        interaction: HelpCenterInteraction.faq,
      ),
    );
  }

  void _onContactPressed(
    HelpCenterContactPressed event,
    Emitter<HelpCenterState> emit,
  ) {
    emit(
      state.copyWith(
        message: 'Tính năng liên hệ hỗ trợ sẽ được nối với chat/support.',
        interaction: HelpCenterInteraction.contact,
      ),
    );
  }

  void _onRequestPressed(
    HelpCenterRequestPressed event,
    Emitter<HelpCenterState> emit,
  ) {
    emit(
      state.copyWith(
        message: 'Tạo yêu cầu hỗ trợ sẽ được triển khai ở bước tiếp theo.',
        interaction: HelpCenterInteraction.request,
      ),
    );
  }

  void _onFeedbackConsumed(
    HelpCenterFeedbackConsumed event,
    Emitter<HelpCenterState> emit,
  ) {
    emit(
      state.copyWith(
        clearMessage: true,
        interaction: HelpCenterInteraction.none,
      ),
    );
  }
}
