import 'package:equatable/equatable.dart';

enum ChatAttachmentType {
  image,
  file,
}

class ChatAttachment extends Equatable {
  const ChatAttachment({
    required this.type,
    required this.name,
    required this.dataUrl,
    this.mimeType,
    this.sizeBytes,
  });

  factory ChatAttachment.fromJson(Map<String, dynamic> json) {
    final typeName = json['type']?.toString();
    return ChatAttachment(
      type: typeName == 'file'
          ? ChatAttachmentType.file
          : ChatAttachmentType.image,
      name: (json['name'] ?? 'attachment').toString(),
      dataUrl: (json['dataUrl'] ?? json['url'] ?? '').toString(),
      mimeType: json['mimeType']?.toString(),
      sizeBytes: json['sizeBytes'] is num
          ? (json['sizeBytes'] as num).toInt()
          : null,
    );
  }

  final ChatAttachmentType type;
  final String name;
  final String dataUrl;
  final String? mimeType;
  final int? sizeBytes;

  bool get isImage => type == ChatAttachmentType.image;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        'dataUrl': dataUrl,
        if (mimeType != null && mimeType!.isNotEmpty) 'mimeType': mimeType,
        if (sizeBytes != null) 'sizeBytes': sizeBytes,
      };

  @override
  List<Object?> get props => [
        type,
        name,
        dataUrl,
        mimeType,
        sizeBytes,
      ];
}
