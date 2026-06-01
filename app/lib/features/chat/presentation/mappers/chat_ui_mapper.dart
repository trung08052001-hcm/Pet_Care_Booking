import 'package:app/features/chat/domain/entities/chat_faq_icon.dart';
import 'package:flutter/material.dart';

abstract final class ChatUiMapper {
  static IconData faqIcon(ChatFaqIcon icon) {
    return switch (icon) {
      ChatFaqIcon.vaccine => Icons.vaccines_outlined,
      ChatFaqIcon.nutrition => Icons.restaurant_outlined,
    };
  }

  static String formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }
}
