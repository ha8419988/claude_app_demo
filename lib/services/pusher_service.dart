import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';

class PusherService {
  static const _appKey = '98f74a5c4aec0bcbcb04';
  static const _cluster = 'ap1';

  PusherClient? _client;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _reconnectController = StreamController<void>.broadcast();
  final _statusController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get newMessages => _messageController.stream;
  Stream<void> get reconnects => _reconnectController.stream;
  Stream<Map<String, dynamic>> get statusUpdates => _statusController.stream;
  Stream<Map<String, dynamic>> get typingUpdates => _typingController.stream;

  void connect(String userId) {
    if (_client != null) return;
    debugPrint('[Pusher] Connecting for user=$userId');
    _client = PusherClient(
      options: PusherOptions(
        key: _appKey,
        cluster: _cluster,
        host: 'ws-$_cluster.pusher.com',
        authOptions: const PusherAuthOptions('http://10.0.2.2:3000/pusher/auth'),
        autoConnect: false,
      ),
    );

    _client!.onConnected((_) => debugPrint('[Pusher] Connected'));
    _client!.onReconnected((_) {
      debugPrint('[Pusher] Reconnected');
      if (!_reconnectController.isClosed) _reconnectController.add(null);
    });
    _client!.onConnectionError((e) => debugPrint('[Pusher] Error: $e'));
    _client!.onDisconnected((_) => debugPrint('[Pusher] Disconnected'));

    final channel = _client!.subscribe('user-$userId');
    channel.bind('new_message', (data) {
      debugPrint('[Pusher] new_message: $data');
      if (!_messageController.isClosed && data is Map) {
        _messageController.add(Map<String, dynamic>.from(data));
      }
    });

    channel.bind('user_status', (data) {
      debugPrint('[Pusher] user_status: $data');
      if (!_statusController.isClosed && data is Map) {
        _statusController.add(Map<String, dynamic>.from(data));
      }
    });

    channel.bind('typing', (data) {
      if (!_typingController.isClosed && data is Map) {
        _typingController.add(Map<String, dynamic>.from(data));
      }
    });

    _client!.connect();
  }

  void disconnect() {
    _client?.disconnect();
    _client = null;
  }
}
