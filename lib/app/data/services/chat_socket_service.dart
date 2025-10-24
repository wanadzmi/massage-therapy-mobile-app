import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/chat_model.dart';

class ChatSocketService extends GetxService {
  IO.Socket? _socket;
  final _isConnected = false.obs;
  final _currentChatId = Rxn<String>();

  bool get isConnected => _isConnected.value;
  String? get currentChatId => _currentChatId.value;

  // Observables for real-time updates
  final newMessage = Rxn<ChatMessage>();
  final readReceipt = Rxn<Map<String, dynamic>>();
  final typingIndicator = Rxn<Map<String, dynamic>>();
  final chatAssigned = Rxn<Map<String, dynamic>>();
  final chatClosed = Rxn<Map<String, dynamic>>();

  Future<ChatSocketService> init() async {
    await _connectSocket();
    return this;
  }

  Future<void> _connectSocket() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        return;
      }

      // Disconnect existing socket if any
      _socket?.disconnect();
      _socket?.dispose();

      _socket = IO.io(
        'https://massage-therapy-backend.onrender.com',
        IO.OptionBuilder()
            .setTransports(['websocket']) // Socket.IO over WebSocket
            .disableAutoConnect() // Manual connection control
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionAttempts(5)
            .setAuth({'token': token}) // JWT for Socket.IO handshake
            .build(),
      );

      _setupSocketListeners();

      // Manually connect to Socket.IO server
      _socket?.connect();
    } catch (e) {}
  }

  void _setupSocketListeners() {
    _socket?.onConnect((_) {
      _isConnected.value = true;

      // Re-join chat if we were in one
      if (_currentChatId.value != null) {
        joinChat(_currentChatId.value!);
      }
    });

    _socket?.onDisconnect((reason) {
      _isConnected.value = false;
    });

    _socket?.onConnectError((error) {
      _isConnected.value = false;
    });

    _socket?.onError((error) {});

    _socket?.onReconnect((attempt) {
      _isConnected.value = true;
    });

    _socket?.onReconnecting((attempt) {});

    _socket?.onReconnectError((error) {});

    _socket?.onReconnectFailed((_) {});

    // Listen for new messages
    _socket?.on('message:new', (data) {
      try {
        if (data is Map<String, dynamic> && data['message'] != null) {
          final message = ChatMessage.fromJson(data['message']);
          newMessage.value = message;
        }
      } catch (e) {}
    });

    // Listen for read receipts
    _socket?.on('message:read_receipt', (data) {
      if (data is Map<String, dynamic>) {
        readReceipt.value = data;
      }
    });

    // Listen for typing indicators
    _socket?.on('typing:user_typing', (data) {
      if (data is Map<String, dynamic>) {
        typingIndicator.value = data;
      }
    });

    // Listen for chat assignments
    _socket?.on('chat:assigned', (data) {
      if (data is Map<String, dynamic>) {
        chatAssigned.value = data;
      }
    });

    // Listen for chat closed events
    _socket?.on('chat:closed', (data) {
      if (data is Map<String, dynamic>) {
        chatClosed.value = data;
      }
    });
  }

  // Join a chat room
  void joinChat(String chatId) {
    if (_socket?.connected == true) {
      _socket?.emit('chat:join', {'chatId': chatId});
      _currentChatId.value = chatId;
    } else {}
  }

  // Leave a chat room
  void leaveChat(String chatId) {
    if (_socket?.connected == true) {
      _socket?.emit('chat:leave', {'chatId': chatId});
      _currentChatId.value = null;
    }
  }

  // Send typing indicator
  void sendTyping(String chatId, bool isTyping) {
    if (_socket?.connected == true) {
      _socket?.emit('chat:typing', {'chatId': chatId, 'isTyping': isTyping});
    }
  }

  // Reconnect socket (useful for re-authentication)
  Future<void> reconnect() async {
    await _connectSocket();
  }

  // Disconnect socket
  void disconnect() {
    if (_socket?.connected == true) {
      _socket?.disconnect();
    }
  }

  @override
  void onClose() {
    disconnect();
    _socket?.dispose();
    super.onClose();
  }
}
