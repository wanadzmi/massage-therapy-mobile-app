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
        print('⚠️ No auth token found for socket connection');
        return;
      }

      // Disconnect existing socket if any
      _socket?.disconnect();
      _socket?.dispose();

      print('🔌 Connecting to Socket.IO server...');
      print('🔑 Token: ${token.substring(0, 20)}...');

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
      print('⏳ Socket.IO connection initiated...');
    } catch (e) {
      print('❌ Socket connection error: $e');
    }
  }

  void _setupSocketListeners() {
    _socket?.onConnect((_) {
      print('✅ Socket.IO connected successfully');
      print('🔗 Socket ID: ${_socket?.id}');
      _isConnected.value = true;

      // Re-join chat if we were in one
      if (_currentChatId.value != null) {
        print('🔄 Rejoining chat: ${_currentChatId.value}');
        joinChat(_currentChatId.value!);
      }
    });

    _socket?.onDisconnect((reason) {
      print('❌ Socket.IO disconnected: $reason');
      _isConnected.value = false;
    });

    _socket?.onConnectError((error) {
      print('❌ Socket.IO connection error: $error');
      print('🔍 Error type: ${error.runtimeType}');
      _isConnected.value = false;
    });

    _socket?.onError((error) {
      print('❌ Socket.IO error: $error');
    });

    _socket?.onReconnect((attempt) {
      print('🔄 Socket.IO reconnected (attempt $attempt)');
      _isConnected.value = true;
    });

    _socket?.onReconnecting((attempt) {
      print('🔄 Socket.IO reconnecting... (attempt $attempt)');
    });

    _socket?.onReconnectError((error) {
      print('❌ Socket.IO reconnection error: $error');
    });

    _socket?.onReconnectFailed((_) {
      print('❌ Socket.IO reconnection failed after all attempts');
    });

    // Listen for new messages
    _socket?.on('message:new', (data) {
      print('📨 New message received: $data');
      try {
        if (data is Map<String, dynamic> && data['message'] != null) {
          final message = ChatMessage.fromJson(data['message']);
          newMessage.value = message;
        }
      } catch (e) {
        print('❌ Error parsing new message: $e');
      }
    });

    // Listen for read receipts
    _socket?.on('message:read_receipt', (data) {
      print('👁️ Read receipt received: $data');
      if (data is Map<String, dynamic>) {
        readReceipt.value = data;
      }
    });

    // Listen for typing indicators
    _socket?.on('typing:user_typing', (data) {
      print('⌨️ Typing indicator received: $data');
      if (data is Map<String, dynamic>) {
        typingIndicator.value = data;
      }
    });

    // Listen for chat assignments
    _socket?.on('chat:assigned', (data) {
      print('👤 Chat assigned: $data');
      if (data is Map<String, dynamic>) {
        chatAssigned.value = data;
      }
    });

    // Listen for chat closed events
    _socket?.on('chat:closed', (data) {
      print('🔒 Chat closed: $data');
      if (data is Map<String, dynamic>) {
        chatClosed.value = data;
      }
    });
  }

  // Join a chat room
  void joinChat(String chatId) {
    if (_socket?.connected == true) {
      print('👋 Joining chat: $chatId');
      _socket?.emit('chat:join', {'chatId': chatId});
      _currentChatId.value = chatId;
    } else {
      print('⚠️ Socket not connected, cannot join chat');
    }
  }

  // Leave a chat room
  void leaveChat(String chatId) {
    if (_socket?.connected == true) {
      print('👋 Leaving chat: $chatId');
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
      print('🔌 Disconnecting socket');
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
