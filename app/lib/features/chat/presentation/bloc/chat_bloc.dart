import 'dart:async';

import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:app/features/chat/domain/usecases/get_chat_page_content_usecase.dart';
import 'package:app/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:app/features/chat/presentation/bloc/chat_event.dart';
import 'package:app/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
    this._getChatPageContentUseCase,
    this._sendChatMessageUseCase,
    this._repository,
  ) : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatRefreshRequested>(_onRefreshRequested);
    on<ChatMessageSendRequested>(_onMessageSendRequested);
    on<ChatIncomingMessageReceived>(_onIncomingMessageReceived);
    on<ChatFaqPressed>(_onFaqPressed);
    on<ChatSeeAllFaqsPressed>(_onSeeAllFaqsPressed);
    on<ChatNotificationsPressed>(_onNotificationsPressed);
    on<ChatAttachmentPressed>(_onAttachmentPressed);
    on<ChatPickImagePressed>(_onPickImagePressed);
    on<ChatPickEmojiPressed>(_onPickEmojiPressed);
  }

  final GetChatPageContentUseCase _getChatPageContentUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final ChatRepository _repository;
  StreamSubscription<ChatMessage>? _messageSubscription;

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) =>
      _loadChat(emit);

  Future<void> _onRefreshRequested(
    ChatRefreshRequested event,
    Emitter<ChatState> emit,
  ) =>
      _loadChat(emit);

  Future<void> _loadChat(Emitter<ChatState> emit) async {
    emit(
      state.copyWith(
        status: ChatStatus.loading,
        isAgentTyping: false,
        isSending: false,
        clearMessage: true,
        interaction: ChatInteraction.none,
      ),
    );

    final result = await _getChatPageContentUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChatStatus.failure,
          message: failure.message,
          messages: const [],
          faqs: const [],
        ),
      ),
      (content) => emit(
        state.copyWith(
          status: ChatStatus.success,
          faqSectionTitle: content.faqSectionTitle,
          todayDividerLabel: content.todayDividerLabel,
          agent: content.agent,
          faqs: content.faqs,
          messages: content.messages,
          isRealtimeConnected: true,
          clearMessage: true,
        ),
      ),
    );
    await _messageSubscription?.cancel();
    _messageSubscription = _repository.incomingMessages.listen(
      (message) => add(ChatIncomingMessageReceived(message)),
    );
  }

  Future<void> _onMessageSendRequested(
    ChatMessageSendRequested event,
    Emitter<ChatState> emit,
  ) async {
    final text = event.text.trim();
    if (text.isEmpty || state.isSending || state.isAgentTyping) {
      return;
    }

    await _sendUserMessage(text, emit);
  }

  Future<void> _onFaqPressed(
    ChatFaqPressed event,
    Emitter<ChatState> emit,
  ) async {
    final faqIndex = state.faqs.indexWhere((item) => item.id == event.faqId);
    if (faqIndex < 0 || state.isSending || state.isAgentTyping) {
      return;
    }
    final faq = state.faqs[faqIndex];

    await _sendUserMessage(faq.prefillMessage, emit);
  }

  Future<void> _sendUserMessage(
    String text,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        isSending: true,
        interaction: ChatInteraction.none,
        clearMessage: true,
      ),
    );

    final result = await _sendChatMessageUseCase(SendChatMessageParams(text));
    result.fold(
      (failure) => emit(
        state.copyWith(
          isSending: false,
          isAgentTyping: false,
          message: failure.message,
        ),
      ),
      (agentMessage) {
        final hasMessage = state.messages.any(
          (message) => message.id == agentMessage.id,
        );
        final updatedMessages = hasMessage
            ? state.messages
            : [...state.messages, agentMessage];

        emit(
          state.copyWith(
            messages: updatedMessages,
            isSending: false,
            isAgentTyping: false,
            clearMessage: true,
          ),
        );
      },
    );
  }

  void _onIncomingMessageReceived(
    ChatIncomingMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final hasMessage = state.messages.any(
      (message) => message.id == event.message.id,
    );
    if (hasMessage) {
      return;
    }

    emit(
      state.copyWith(
        messages: [...state.messages, event.message],
        isAgentTyping: false,
        isRealtimeConnected: true,
        clearMessage: true,
      ),
    );
  }

  void _onSeeAllFaqsPressed(
    ChatSeeAllFaqsPressed event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(interaction: ChatInteraction.seeAllFaqs),
    );
  }

  void _onNotificationsPressed(
    ChatNotificationsPressed event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(interaction: ChatInteraction.notifications),
    );
  }

  void _onAttachmentPressed(
    ChatAttachmentPressed event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(interaction: ChatInteraction.attachment),
    );
  }

  void _onPickImagePressed(
    ChatPickImagePressed event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(interaction: ChatInteraction.pickImage),
    );
  }

  void _onPickEmojiPressed(
    ChatPickEmojiPressed event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(interaction: ChatInteraction.pickEmoji),
    );
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    return super.close();
  }
}
