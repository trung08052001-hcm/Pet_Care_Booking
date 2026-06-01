import 'package:app/features/chat/domain/entities/chat_faq_icon.dart';
import 'package:equatable/equatable.dart';

class ChatFaqItem extends Equatable {
  const ChatFaqItem({
    required this.id,
    required this.question,
    required this.icon,
    required this.prefillMessage,
  });

  final String id;
  final String question;
  final ChatFaqIcon icon;
  final String prefillMessage;

  @override
  List<Object?> get props => [id, question, icon, prefillMessage];
}
