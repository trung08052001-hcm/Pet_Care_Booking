import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/chat/domain/entities/chat_agent.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_message_sender.dart';
import 'package:app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:app/features/chat/presentation/bloc/chat_event.dart';
import 'package:app/features/chat/presentation/bloc/chat_state.dart';
import 'package:app/features/chat/presentation/mappers/chat_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.messages.length != current.messages.length ||
          previous.isAgentTyping != current.isAgentTyping,
      listener: (context, state) => _scrollToBottom(),
      builder: (context, state) {
        if (state.status == ChatStatus.failure) {
          return _ChatErrorView(
            message: state.message ?? 'Không tải được cuộc trò chuyện.',
            onRetry: () =>
                context.read<ChatBloc>().add(const ChatRefreshRequested()),
          );
        }

        if (state.isLoading || state.agent == null) {
          return const ColoredBox(
            color: Color(0xFFF3F8FB),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return _ChatBody(
          state: state,
          scrollController: _scrollController,
          messageController: _messageController,
          onSend: () {
            final text = _messageController.text;
            context.read<ChatBloc>().add(ChatMessageSendRequested(text));
            _messageController.clear();
          },
        );
      },
    );
  }
}

class _ChatErrorView extends StatelessWidget {
  const _ChatErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF3F8FB),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.mutedText),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.state,
    required this.scrollController,
    required this.messageController,
    required this.onSend,
  });

  final ChatState state;
  final ScrollController scrollController;
  final TextEditingController messageController;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatBloc>();

    return ColoredBox(
      color: const Color(0xFFF3F8FB),
      child: SafeArea(
        child: Column(
          children: [
            _ChatAppBar(
              onNotificationsPressed: () =>
                  bloc.add(const ChatNotificationsPressed()),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  _DateDivider(label: state.todayDividerLabel),
                  const SizedBox(height: 16),
                  for (final message in state.messages)
                    _MessageBubble(
                      message: message,
                      agent: state.agent!,
                    ),
                  if (state.isAgentTyping)
                    _TypingIndicator(agent: state.agent!),
                ],
              ),
            ),
            _ChatInputBar(
              controller: messageController,
              enabled: !state.isSending && !state.isAgentTyping,
              onSend: onSend,
              onAttachment: () => bloc.add(const ChatAttachmentPressed()),
              onPickImage: () => bloc.add(const ChatPickImagePressed()),
              onPickEmoji: () => bloc.add(const ChatPickEmojiPressed()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  const _ChatAppBar({required this.onNotificationsPressed});

  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'PawSitive Care',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.brown,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onNotificationsPressed,
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.brownText,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.divider.withValues(alpha: 0.9))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: AppColors.mutedText.withValues(alpha: 0.9),
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.divider.withValues(alpha: 0.9))),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.agent,
  });

  final ChatMessage message;
  final ChatAgent agent;

  bool get _isUser => message.sender == ChatMessageSender.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!_isUser) ...[
            _AgentAvatar(agent: agent),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _isUser
                        ? AppColors.brown
                        : const Color(0xFFE8EEF2),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(_isUser ? 18 : 4),
                      bottomRight: Radius.circular(_isUser ? 4 : 18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: _isUser ? Colors.white : AppColors.brownText,
                        ),
                      ),
                      if (message.hasImageAttachment) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: _isUser ? 0.15 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.insert_chart_outlined_rounded,
                                size: 36,
                                color: _isUser
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : AppColors.primary,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                message.imageAttachmentTitle!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _isUser
                                      ? Colors.white
                                      : AppColors.brownText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ChatUiMapper.formatTime(message.sentAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedText,
                      ),
                    ),
                    if (_isUser && message.isRead) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.done_all_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentAvatar extends StatelessWidget {
  const _AgentAvatar({required this.agent});

  final ChatAgent agent;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
      child: Text(
        agent.avatarInitials ??
            (agent.name.isNotEmpty ? agent.name[0] : '?'),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.agent});

  final ChatAgent agent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          _AgentAvatar(agent: agent),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEF2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              '• • •',
              style: TextStyle(
                fontSize: 18,
                height: 0.5,
                color: AppColors.mutedText,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.enabled,
    required this.onSend,
    required this.onAttachment,
    required this.onPickImage,
    required this.onPickEmoji,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onPickImage;
  final VoidCallback onPickEmoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: enabled ? onAttachment : null,
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: AppColors.brownText,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              textInputAction: TextInputAction.send,
              onSubmitted: enabled ? (_) => onSend() : null,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: TextStyle(
                  color: AppColors.mutedText.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F7F8),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: enabled ? onPickImage : null,
                      icon: const Icon(Icons.image_outlined, size: 22),
                      color: AppColors.mutedText,
                    ),
                    IconButton(
                      onPressed: enabled ? onPickEmoji : null,
                      icon: const Icon(Icons.emoji_emotions_outlined, size: 22),
                      color: AppColors.mutedText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: enabled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.4),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: enabled ? onSend : null,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
