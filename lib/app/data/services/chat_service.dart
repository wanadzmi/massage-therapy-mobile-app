import '../models/chat_model.dart';
import 'base_services.dart';

class ChatService extends BaseServices {
  static const String _chatsEndpoint = '/api/chats';

  /// Get all user's chats
  Future<MyResponse<ChatsData?, dynamic>> getChats({
    String? status,
    String? type,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String>[];
    queryParams.add('page=$page');
    queryParams.add('limit=$limit');

    if (status != null) queryParams.add('status=$status');
    if (type != null) queryParams.add('type=$type');

    String endpoint = _chatsEndpoint;
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await callAPI(HttpRequestType.GET, endpoint);

    if (response.isSuccess && response.data != null) {
      try {
        final chatsResponse = ChatsResponse.fromJson(response.data);
        return MyResponse.complete(chatsResponse.data);
      } catch (e) {
        return MyResponse.error('Failed to parse chats data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Create new chat
  Future<MyResponse<Chat?, dynamic>> createChat({
    required String type,
    required String message,
    String? subject,
    String? bookingId,
    String? category,
    String? priority,
  }) async {
    final postBody = <String, dynamic>{'type': type, 'message': message};

    if (subject != null) postBody['subject'] = subject;
    if (bookingId != null) postBody['bookingId'] = bookingId;
    if (category != null) postBody['category'] = category;
    if (priority != null) postBody['priority'] = priority;

    final response = await callAPI(
      HttpRequestType.POST,
      _chatsEndpoint,
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final chatData = response.data['data'] ?? response.data;
        final chat = Chat.fromJson(chatData);
        return MyResponse.complete(chat);
      } catch (e) {
        return MyResponse.error('Failed to parse chat data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get chat details
  Future<MyResponse<Chat?, dynamic>> getChatDetails(String chatId) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_chatsEndpoint/$chatId',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final chatData = response.data['data'] ?? response.data;
        final chat = Chat.fromJson(chatData);
        return MyResponse.complete(chat);
      } catch (e) {
        return MyResponse.error('Failed to parse chat data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get chat messages
  Future<MyResponse<MessagesData?, dynamic>> getChatMessages(
    String chatId, {
    int page = 1,
    int limit = 50,
    String? before,
    String? after,
  }) async {
    final queryParams = <String>[];
    queryParams.add('page=$page');
    queryParams.add('limit=$limit');

    if (before != null) queryParams.add('before=$before');
    if (after != null) queryParams.add('after=$after');

    String endpoint = '$_chatsEndpoint/$chatId/messages';
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await callAPI(HttpRequestType.GET, endpoint);

    if (response.isSuccess && response.data != null) {
      try {
        final messagesResponse = MessagesResponse.fromJson(response.data);
        return MyResponse.complete(messagesResponse.data);
      } catch (e) {
        return MyResponse.error('Failed to parse messages data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Send message
  Future<MyResponse<ChatMessage?, dynamic>> sendMessage(
    String chatId, {
    required String text,
    String type = 'text',
    String? replyTo,
    List<Map<String, dynamic>>? attachments,
  }) async {
    final postBody = <String, dynamic>{'text': text, 'type': type};

    if (replyTo != null) postBody['replyTo'] = replyTo;
    if (attachments != null && attachments.isNotEmpty) {
      postBody['attachments'] = attachments;
    }

    final response = await callAPI(
      HttpRequestType.POST,
      '$_chatsEndpoint/$chatId/messages',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final messageData = response.data['data'] ?? response.data;
        final message = ChatMessage.fromJson(messageData);
        return MyResponse.complete(message);
      } catch (e) {
        return MyResponse.error('Failed to parse message data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Send typing indicator
  Future<MyResponse<void, dynamic>> sendTypingIndicator(
    String chatId,
    bool isTyping,
  ) async {
    final postBody = {'isTyping': isTyping};

    final response = await callAPI(
      HttpRequestType.POST,
      '$_chatsEndpoint/$chatId/typing',
      postBody: postBody,
    );

    if (response.isSuccess) {
      return MyResponse.complete(null);
    }

    return MyResponse.error(response.error);
  }

  /// Close chat
  Future<MyResponse<Map<String, dynamic>?, dynamic>> closeChat(
    String chatId, {
    String? feedback,
    int? rating,
  }) async {
    final putBody = <String, dynamic>{};

    if (feedback != null) putBody['feedback'] = feedback;
    if (rating != null) putBody['rating'] = rating;

    final response = await callAPI(
      HttpRequestType.PUT,
      '$_chatsEndpoint/$chatId/close',
      postBody: putBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final closedData = response.data['data'] ?? response.data;
        return MyResponse.complete(closedData as Map<String, dynamic>?);
      } catch (e) {
        return MyResponse.error('Failed to parse close chat data: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}
