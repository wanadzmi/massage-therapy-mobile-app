class Chat {
  final String? id;
  final String? chatId;
  final String? type;
  final String? status;
  final List<Participant>? participants;
  final LastMessage? lastMessage;
  final ChatContext? context;
  final Assignment? assignment;
  final ChatMetadata? metadata;
  final Statistics? statistics;
  final DateTime? lastActivity;
  final int? unreadCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    this.id,
    this.chatId,
    this.type,
    this.status,
    this.participants,
    this.lastMessage,
    this.context,
    this.assignment,
    this.metadata,
    this.statistics,
    this.lastActivity,
    this.unreadCount,
    this.createdAt,
    this.updatedAt,
  });

  // Convenience getters
  String? get subject => metadata?.subject;
  String? get category => context?.category;

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? json['id'],
      chatId: json['chatId'],
      type: json['type'],
      status: json['status'],
      participants: json['participants'] != null
          ? (json['participants'] as List)
                .map((p) => Participant.fromJson(p))
                .toList()
          : null,
      lastMessage: json['lastMessage'] != null
          ? LastMessage.fromJson(json['lastMessage'])
          : null,
      context: json['context'] != null
          ? ChatContext.fromJson(json['context'])
          : null,
      assignment: json['assignment'] != null
          ? Assignment.fromJson(json['assignment'])
          : null,
      metadata: json['metadata'] != null
          ? ChatMetadata.fromJson(json['metadata'])
          : null,
      statistics: json['statistics'] != null
          ? Statistics.fromJson(json['statistics'])
          : null,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'])
          : null,
      unreadCount: json['unreadCount'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'type': type,
      'status': status,
      'participants': participants?.map((p) => p.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'context': context?.toJson(),
      'assignment': assignment?.toJson(),
      'metadata': metadata?.toJson(),
      'statistics': statistics?.toJson(),
      'lastActivity': lastActivity?.toIso8601String(),
      'unreadCount': unreadCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Participant {
  final ParticipantUser? user;
  final String? role;
  final DateTime? joinedAt;
  final bool? isActive;

  Participant({this.user, this.role, this.joinedAt, this.isActive});

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      user: json['user'] != null
          ? ParticipantUser.fromJson(json['user'])
          : null,
      role: json['role'],
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'])
          : null,
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'role': role,
      'joinedAt': joinedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }
}

class ParticipantUser {
  final String? id;
  final String? name;
  final String? avatar;
  final String? role;

  ParticipantUser({this.id, this.name, this.avatar, this.role});

  factory ParticipantUser.fromJson(Map<String, dynamic> json) {
    return ParticipantUser(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      avatar: json['avatar'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatar': avatar, 'role': role};
  }
}

class LastMessage {
  final String? id;
  final MessageContent? content;
  final String? status;
  final DateTime? createdAt;

  LastMessage({this.id, this.content, this.status, this.createdAt});

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id'] ?? json['id'],
      content: json['content'] != null
          ? MessageContent.fromJson(json['content'])
          : null,
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content?.toJson(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class MessageContent {
  final String? text;
  final String? type;

  MessageContent({this.text, this.type});

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(text: json['text'], type: json['type']);
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'type': type};
  }
}

class ChatContext {
  final dynamic bookingId;
  final String? category;
  final String? priority;

  ChatContext({this.bookingId, this.category, this.priority});

  factory ChatContext.fromJson(Map<String, dynamic> json) {
    return ChatContext(
      bookingId: json['bookingId'],
      category: json['category'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'bookingId': bookingId, 'category': category, 'priority': priority};
  }
}

class Assignment {
  final AssignedAgent? assignedAgent;
  final DateTime? assignedAt;
  final String? assignmentMethod;

  Assignment({this.assignedAgent, this.assignedAt, this.assignmentMethod});

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      assignedAgent: json['assignedAgent'] != null
          ? AssignedAgent.fromJson(json['assignedAgent'])
          : null,
      assignedAt: json['assignedAt'] != null
          ? DateTime.parse(json['assignedAt'])
          : null,
      assignmentMethod: json['assignmentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignedAgent': assignedAgent?.toJson(),
      'assignedAt': assignedAt?.toIso8601String(),
      'assignmentMethod': assignmentMethod,
    };
  }
}

class AssignedAgent {
  final String? id;
  final String? name;
  final String? avatar;
  final String? role;

  AssignedAgent({this.id, this.name, this.avatar, this.role});

  factory AssignedAgent.fromJson(Map<String, dynamic> json) {
    return AssignedAgent(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      avatar: json['avatar'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatar': avatar, 'role': role};
  }
}

class ChatMetadata {
  final String? subject;
  final List<String>? tags;
  final String? language;

  ChatMetadata({this.subject, this.tags, this.language});

  factory ChatMetadata.fromJson(Map<String, dynamic> json) {
    return ChatMetadata(
      subject: json['subject'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'tags': tags, 'language': language};
  }
}

class Statistics {
  final int? messageCount;
  final int? duration;

  Statistics({this.messageCount, this.duration});

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      messageCount: json['messageCount'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'messageCount': messageCount, 'duration': duration};
  }
}

class ChatMessage {
  final String? id;
  final String? messageId;
  final String? chat;
  final MessageSender? sender;
  final MessageContent? content;
  final String? status;
  final MessageDelivery? delivery;
  final List<MessageAttachment>? attachments;
  final String? replyTo;
  final bool? isEdited;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatMessage({
    this.id,
    this.messageId,
    this.chat,
    this.sender,
    this.content,
    this.status,
    this.delivery,
    this.attachments,
    this.replyTo,
    this.isEdited,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? json['id'],
      messageId: json['messageId'],
      chat: json['chat'],
      sender: json['sender'] != null
          ? MessageSender.fromJson(json['sender'])
          : null,
      content: json['content'] != null
          ? MessageContent.fromJson(json['content'])
          : null,
      status: json['status'],
      delivery: json['delivery'] != null
          ? MessageDelivery.fromJson(json['delivery'])
          : null,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
                .map((a) => MessageAttachment.fromJson(a))
                .toList()
          : null,
      replyTo: json['replyTo'],
      isEdited: json['isEdited'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageId': messageId,
      'chat': chat,
      'sender': sender?.toJson(),
      'content': content?.toJson(),
      'status': status,
      'delivery': delivery?.toJson(),
      'attachments': attachments?.map((a) => a.toJson()).toList(),
      'replyTo': replyTo,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper to check if message is from current user
  bool isFromMe(String currentUserId) {
    return sender?.id == currentUserId;
  }
}

class MessageSender {
  final String? id;
  final String? name;
  final String? avatar;
  final String? role;

  MessageSender({this.id, this.name, this.avatar, this.role});

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      avatar: json['avatar'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'avatar': avatar, 'role': role};
  }
}

class MessageDelivery {
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final List<ReadReceipt>? readBy;

  MessageDelivery({this.sentAt, this.deliveredAt, this.readBy});

  factory MessageDelivery.fromJson(Map<String, dynamic> json) {
    return MessageDelivery(
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      readBy: json['readBy'] != null
          ? (json['readBy'] as List)
                .map((r) => ReadReceipt.fromJson(r))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentAt': sentAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'readBy': readBy?.map((r) => r.toJson()).toList(),
    };
  }
}

class ReadReceipt {
  final String? user;
  final DateTime? readAt;

  ReadReceipt({this.user, this.readAt});

  factory ReadReceipt.fromJson(Map<String, dynamic> json) {
    return ReadReceipt(
      user: json['user'],
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user, 'readAt': readAt?.toIso8601String()};
  }
}

class MessageAttachment {
  final String? type;
  final String? url;
  final String? filename;
  final int? size;
  final String? mimeType;
  final String? thumbnail;

  MessageAttachment({
    this.type,
    this.url,
    this.filename,
    this.size,
    this.mimeType,
    this.thumbnail,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      type: json['type'],
      url: json['url'],
      filename: json['filename'],
      size: json['size'],
      mimeType: json['mimeType'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'filename': filename,
      'size': size,
      'mimeType': mimeType,
      'thumbnail': thumbnail,
    };
  }
}

// Response Models

class ChatsResponse {
  final String? message;
  final ChatsData? data;

  ChatsResponse({this.message, this.data});

  factory ChatsResponse.fromJson(Map<String, dynamic> json) {
    return ChatsResponse(
      message: json['message'],
      data: json['data'] != null ? ChatsData.fromJson(json['data']) : null,
    );
  }
}

class ChatsData {
  final List<Chat>? chats;
  final ChatPagination? pagination;

  ChatsData({this.chats, this.pagination});

  factory ChatsData.fromJson(Map<String, dynamic> json) {
    return ChatsData(
      chats: json['chats'] != null
          ? (json['chats'] as List).map((c) => Chat.fromJson(c)).toList()
          : null,
      pagination: json['pagination'] != null
          ? ChatPagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class ChatPagination {
  final int? current;
  final int? total;
  final int? limit;
  final int? totalChats;

  ChatPagination({this.current, this.total, this.limit, this.totalChats});

  factory ChatPagination.fromJson(Map<String, dynamic> json) {
    return ChatPagination(
      current: json['current'],
      total: json['total'],
      limit: json['limit'],
      totalChats: json['totalChats'],
    );
  }
}

class MessagesResponse {
  final String? message;
  final MessagesData? data;

  MessagesResponse({this.message, this.data});

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return MessagesResponse(
      message: json['message'],
      data: json['data'] != null ? MessagesData.fromJson(json['data']) : null,
    );
  }
}

class MessagesData {
  final List<ChatMessage>? messages;
  final bool? hasMore;
  final String? chatStatus;

  MessagesData({this.messages, this.hasMore, this.chatStatus});

  factory MessagesData.fromJson(Map<String, dynamic> json) {
    return MessagesData(
      messages: json['messages'] != null
          ? (json['messages'] as List)
                .map((m) => ChatMessage.fromJson(m))
                .toList()
          : null,
      hasMore: json['hasMore'],
      chatStatus: json['chatStatus'],
    );
  }
}
