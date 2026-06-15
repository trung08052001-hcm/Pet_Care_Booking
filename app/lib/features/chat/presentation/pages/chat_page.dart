import 'dart:convert';
import 'dart:typed_data';

import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/chat/domain/entities/chat_agent.dart';
import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_message_sender.dart';
import 'package:app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:app/features/chat/presentation/bloc/chat_event.dart';
import 'package:app/features/chat/presentation/bloc/chat_state.dart';
import 'package:app/features/chat/presentation/mappers/chat_ui_mapper.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();
  final _imagePicker = ImagePicker();

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

  void _sendText() {
    final text = _messageController.text;
    context.read<ChatBloc>().add(ChatMessageSendRequested(text));
    _messageController.clear();
  }

  void _sendAttachment(ChatAttachment attachment) {
    final text = _messageController.text.trim();
    context.read<ChatBloc>().add(
          ChatMessageSendRequested(
            text,
            attachments: [attachment],
          ),
        );
    _messageController.clear();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 76,
      maxWidth: 1600,
    );
    if (file == null || !mounted) {
      return;
    }

    final bytes = await file.readAsBytes();
    final mimeType = _mimeTypeFromName(file.name, fallback: 'image/jpeg');
    _sendAttachment(
      ChatAttachment(
        type: ChatAttachmentType.image,
        name: file.name,
        dataUrl: 'data:$mimeType;base64,${base64Encode(bytes)}',
        mimeType: mimeType,
        sizeBytes: bytes.length,
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await file_picker.FilePicker.pickFiles(
      allowMultiple: false,
      withData: true,
    );
    final file = result?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null || !mounted) {
      return;
    }

    if (bytes.length > 5 * 1024 * 1024) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Tệp tối đa 5MB.')),
        );
      return;
    }

    final mimeType = _mimeTypeFromName(file.name);
    _sendAttachment(
      ChatAttachment(
        type: mimeType.startsWith('image/')
            ? ChatAttachmentType.image
            : ChatAttachmentType.file,
        name: file.name,
        dataUrl: 'data:$mimeType;base64,${base64Encode(bytes)}',
        mimeType: mimeType,
        sizeBytes: bytes.length,
      ),
    );
  }

  Future<void> _showAttachmentSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AttachmentAction(
                icon: Icons.insert_drive_file_outlined,
                label: 'Chọn tệp',
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
              _AttachmentAction(
                icon: Icons.photo_library_outlined,
                label: 'Chọn ảnh từ thư viện',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              _AttachmentAction(
                icon: Icons.photo_camera_outlined,
                label: 'Chụp ảnh',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEmojiSheet() async {
    const emojis = [
      '😀', '😂', '🥰', '😍', '😊', '😢', '🙏', '👍',
      '❤️', '🐶', '🐱', '🐾', '🦴', '💉', '🛁', '🏥',
    ];

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: GridView.count(
            crossAxisCount: 8,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            children: [
              for (final emoji in emojis)
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.pop(context);
                    _insertEmoji(emoji);
                  },
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _insertEmoji(String emoji) {
    final value = _messageController.value;
    final selection = value.selection;
    final start = selection.start < 0 ? value.text.length : selection.start;
    final end = selection.end < 0 ? value.text.length : selection.end;
    final text = value.text.replaceRange(start, end, emoji);
    _messageController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  String _mimeTypeFromName(String name, {String fallback = 'application/octet-stream'}) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.txt')) return 'text/plain';
    if (lower.endsWith('.doc')) return 'application/msword';
    if (lower.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
    return fallback;
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
          onSend: _sendText,
          onAttachment: _showAttachmentSheet,
          onPickImage: () => _pickImage(ImageSource.gallery),
          onPickEmoji: _showEmojiSheet,
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

class _AttachmentAction extends StatelessWidget {
  const _AttachmentAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.brownText,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.state,
    required this.scrollController,
    required this.messageController,
    required this.onSend,
    required this.onAttachment,
    required this.onPickImage,
    required this.onPickEmoji,
  });

  final ChatState state;
  final ScrollController scrollController;
  final TextEditingController messageController;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onPickImage;
  final VoidCallback onPickEmoji;

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
                  const _WelcomeCard(),
                  const SizedBox(height: 18),
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
              onAttachment: onAttachment,
              onPickImage: onPickImage,
              onPickEmoji: onPickEmoji,
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
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.brownText,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: AppColors.divider.withValues(alpha: 0.7)),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets_rounded,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PawSitive Care',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brown,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Luôn sẵn sàng chăm sóc thú cưng của bạn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Color(0xFF22B14C)),
                    SizedBox(width: 5),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF22B14C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNotificationsPressed,
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.brownText,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.brownText,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3EA),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Center(
              child: Text(
                '🐶',
                style: TextStyle(fontSize: 52),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Chào mừng bạn đến với PawSitive Care! 🐾\n'
              'Hãy nhắn tin cho chúng tôi nếu bạn cần tư vấn hoặc hỗ trợ về thú cưng nhé.',
              style: TextStyle(
                color: AppColors.brownText,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
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

  List<int>? _decodeDataUrl(String dataUrl) {
    final commaIndex = dataUrl.indexOf(',');
    if (!dataUrl.startsWith('data:') || commaIndex < 0) {
      return null;
    }
    try {
      return base64Decode(dataUrl.substring(commaIndex + 1));
    } on FormatException {
      return null;
    }
  }

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
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: _isUser ? Colors.white : AppColors.brownText,
                          ),
                        ),
                      for (final attachment in message.attachments) ...[
                        if (message.text.isNotEmpty) const SizedBox(height: 10),
                        if (attachment.isImage)
                          _ChatImageAttachment(
                            bytes: _decodeDataUrl(attachment.dataUrl),
                            name: attachment.name,
                            isUser: _isUser,
                          )
                        else
                          _ChatFileAttachment(
                            attachment: attachment,
                            isUser: _isUser,
                          ),
                      ],
                      if (message.attachments.isEmpty &&
                          message.hasImageAttachment) ...[
                        if (message.text.isNotEmpty) const SizedBox(height: 10),
                        _ChatFileAttachment(
                          attachment: ChatAttachment(
                            type: ChatAttachmentType.file,
                            name: message.imageAttachmentTitle!,
                            dataUrl: '',
                          ),
                          isUser: _isUser,
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
                      _statusLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedText,
                      ),
                    ),
                    if (_isUser &&
                        message.deliveryStatus ==
                            ChatMessageDeliveryStatus.sending) ...[
                      const SizedBox(width: 4),
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(strokeWidth: 1.4),
                      ),
                    ] else if (_isUser && message.isRead) ...[
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

  String get _statusLabel {
    if (!_isUser) {
      return ChatUiMapper.formatTime(message.sentAt);
    }

    return switch (message.deliveryStatus) {
      ChatMessageDeliveryStatus.sending => 'Đang gửi...',
      ChatMessageDeliveryStatus.failed => 'Chưa gửi',
      ChatMessageDeliveryStatus.sent => ChatUiMapper.formatTime(message.sentAt),
    };
  }
}

class _ChatImageAttachment extends StatelessWidget {
  const _ChatImageAttachment({
    required this.bytes,
    required this.name,
    required this.isUser,
  });

  final List<int>? bytes;
  final String name;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    if (bytes == null) {
      return _ChatFileAttachment(
        attachment: ChatAttachment(
          type: ChatAttachmentType.file,
          name: name,
          dataUrl: '',
        ),
        isUser: isUser,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 230,
          maxHeight: 260,
        ),
        child: Image.memory(
          Uint8List.fromList(bytes!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ChatFileAttachment extends StatelessWidget {
  const _ChatFileAttachment({
    required this.attachment,
    required this.isUser,
  });

  final ChatAttachment attachment;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isUser ? 0.15 : 1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUser
              ? Colors.white.withValues(alpha: 0.22)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            attachment.isImage
                ? Icons.image_outlined
                : Icons.insert_drive_file_outlined,
            size: 26,
            color: isUser ? Colors.white : AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isUser ? Colors.white : AppColors.brownText,
                  ),
                ),
                if (attachment.sizeBytes != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _formatSize(attachment.sizeBytes!),
                    style: TextStyle(
                      fontSize: 11,
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.75)
                          : AppColors.mutedText,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
