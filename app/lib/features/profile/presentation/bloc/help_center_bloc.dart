import 'package:app/features/profile/domain/usecases/get_help_center_content_usecase.dart';
import 'package:app/features/profile/presentation/bloc/help_center_event.dart';
import 'package:app/features/profile/presentation/bloc/help_center_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpCenterBloc extends Bloc<HelpCenterEvent, HelpCenterState> {
  HelpCenterBloc(this._getHelpCenterContentUseCase)
      : super(const HelpCenterState()) {
    on<HelpCenterStarted>(_onStarted);
    on<HelpCenterCategoryPressed>(_onCategoryPressed);
    on<HelpCenterFaqPressed>(_onFaqPressed);
    on<HelpCenterContactPressed>(_onContactPressed);
    on<HelpCenterRequestPressed>(_onRequestPressed);
    on<HelpCenterFeedbackSubmitted>(_onFeedbackSubmitted);
    on<HelpCenterFeedbackConsumed>(_onFeedbackConsumed);
  }

  final GetHelpCenterContentUseCase _getHelpCenterContentUseCase;

  Future<void> _onStarted(
    HelpCenterStarted event,
    Emitter<HelpCenterState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HelpCenterStatus.loading,
        clearMessage: true,
        interaction: HelpCenterInteraction.none,
      ),
    );

    try {
      final content = await _getHelpCenterContentUseCase();
      emit(
        state.copyWith(
          status: HelpCenterStatus.ready,
          content: content,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: HelpCenterStatus.failure,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void _onCategoryPressed(
    HelpCenterCategoryPressed event,
    Emitter<HelpCenterState> emit,
  ) {
    emit(
      state.copyWith(
        message: 'Đang mở thông tin hỗ trợ ${event.name}.',
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

  Future<void> _onFeedbackSubmitted(
    HelpCenterFeedbackSubmitted event,
    Emitter<HelpCenterState> emit,
  ) async {
    final message = event.message.trim();
    if (message.isEmpty) {
      emit(
        state.copyWith(
          message: 'Vui lòng nhập nội dung cần hỗ trợ.',
          interaction: HelpCenterInteraction.request,
        ),
      );
      return;
    }

    try {
      await _getHelpCenterContentUseCase.submitFeedback(message);
      emit(
        state.copyWith(
          message: 'Đã gửi yêu cầu hỗ trợ.',
          interaction: HelpCenterInteraction.request,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          message: error.toString().replaceFirst('Exception: ', ''),
          interaction: HelpCenterInteraction.request,
        ),
      );
    }
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
