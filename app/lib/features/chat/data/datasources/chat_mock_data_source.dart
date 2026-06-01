import 'package:app/features/chat/domain/entities/chat_agent.dart';
import 'package:app/features/chat/domain/entities/chat_faq_icon.dart';
import 'package:app/features/chat/domain/entities/chat_faq_item.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_message_sender.dart';
import 'package:app/features/chat/domain/entities/chat_page_content.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatMockDataSource {
  int _messageCounter = 100;

  ChatPageContent getPageContent() {
    return ChatPageContent(
      faqSectionTitle: 'Câu hỏi thường gặp',
      todayDividerLabel: 'HÔM NAY',
      agent: const ChatAgent(
        name: 'Linh',
        role: 'Chuyên viên tư vấn',
        avatarInitials: 'LT',
      ),
      faqs: const [
        ChatFaqItem(
          id: 'faq-vaccine',
          question: 'Lịch tiêm phòng cho mèo con?',
          icon: ChatFaqIcon.vaccine,
          prefillMessage: 'Cho mình hỏi lịch tiêm phòng cho mèo con với ạ?',
        ),
        ChatFaqItem(
          id: 'faq-diet',
          question: 'Chế độ ăn cho chó già?',
          icon: ChatFaqIcon.nutrition,
          prefillMessage: 'Chó già nhà mình nên ăn chế độ như thế nào ạ?',
        ),
      ],
      messages: [
        ChatMessage(
          id: 'msg-1',
          sender: ChatMessageSender.agent,
          text:
              'Chào bạn! Tôi là Linh, chuyên viên tư vấn của PawSitive Care. '
              'Tôi có thể giúp gì cho bé cưng của bạn hôm nay ạ?',
          sentAt: ChatMockTimes.am930,
        ),
        ChatMessage(
          id: 'msg-2',
          sender: ChatMessageSender.user,
          text:
              'Chào Linh, bé Corgi nhà mình dạo này hơi biếng ăn và lười vận động. '
              'Bạn tư vấn giúp mình nhé.',
          sentAt: ChatMockTimes.am932,
          isRead: true,
        ),
        ChatMessage(
          id: 'msg-3',
          sender: ChatMessageSender.agent,
          text:
              'Cảm ơn bạn đã chia sẻ. Biếng ăn có thể do thay đổi thời tiết, '
              'stress hoặc chế độ dinh dưỡng. Dưới đây là bảng theo dõi sức khỏe '
              'tham khảo cho bé Corgi:',
          sentAt: ChatMockTimes.am935,
          imageAttachmentTitle: 'Pet Health Chart',
        ),
      ],
    );
  }

  ChatMessage createUserMessage(String text) {
    _messageCounter++;
    return ChatMessage(
      id: 'msg-user-$_messageCounter',
      sender: ChatMessageSender.user,
      text: text,
      sentAt: DateTime.now(),
      isRead: false,
    );
  }

  ChatMessage createAgentReply(String userMessage) {
    _messageCounter++;
    final lower = userMessage.toLowerCase();

    if (lower.contains('tiêm') || lower.contains('mèo con')) {
      return ChatMessage(
        id: 'msg-agent-$_messageCounter',
        sender: ChatMessageSender.agent,
        text:
            'Với mèo con, bạn nên tiêm vaccine 3 mũi cơ bản trong 12 tuần đầu, '
            'sau đó nhắc lại hàng năm. PawSitive Care có gói tư vấn miễn phí '
            'khi đặt lịch khám tại phòng khám đối tác.',
        sentAt: DateTime.now(),
      );
    }

    if (lower.contains('chó già') || lower.contains('chế độ ăn')) {
      return ChatMessage(
        id: 'msg-agent-$_messageCounter',
        sender: ChatMessageSender.agent,
        text:
            'Chó già cần thức ăn dễ tiêu, giàu protein chất lượng cao và ít muối. '
            'Bạn có thể chia 2–3 bữa nhỏ mỗi ngày và theo dõi cân nặng định kỳ.',
        sentAt: DateTime.now(),
      );
    }

    return ChatMessage(
      id: 'msg-agent-$_messageCounter',
      sender: ChatMessageSender.agent,
      text:
          'Mình đã ghi nhận thông tin. Bạn có thể mô tả thêm triệu chứng hoặc thói '
          'quen ăn uống của bé để mình tư vấn chi tiết hơn nhé!',
      sentAt: DateTime.now(),
    );
  }
}

abstract final class ChatMockTimes {
  static final am930 = DateTime(2026, 5, 28, 9, 30);
  static final am932 = DateTime(2026, 5, 28, 9, 32);
  static final am935 = DateTime(2026, 5, 28, 9, 35);
}
