import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

class Client {
  // late TcpSocketConnection _socketConnection;
  late Socket _socket;
  late String _ip;
  late int _port;
  late TcpClient _client;
  List<Map<String, dynamic>> _msg = [];
  List<String> _responses = [];
  String _tmpMesssage = "";
  bool _firstMessage = false;
  // late Stream<String> _listener;

  Future<void> initialize(String ip, int port) async {
    TcpClient.debug = false;
    _client = await TcpClient.connect(ip, port, timeout: const Duration(seconds: 10));
  }

  void sendMessage(Map<String, dynamic> msg) {
    String toSend = JsonEncoder().convert(msg).trim();
    _client.write(toSend);
  }

  void startClient() async {
    _client.connectionStream.listen((event) {
      debugPrint("[TCP CLIENT]: NEW MESSAGE (${event})");
    });

    _client.stringStream.listen((event) {
      if (!event.contains("connected")) {
        _msg.add(jsonDecode(event));
        debugPrint("adding message");
      }
      debugPrint("[TCP CLIENT]: NEW MESSAGE (${event})");
    });
  }

  void readMessage(String msg) {
    debugPrint("[TCP CLIENT]: NEW MESSAGE (${msg})");
  }

  void launchClient() async {
    bool doneOne = false;
    var listener = _socket.listen((event) {
      String message = utf8.decode(event);
      _msg.add(jsonDecode(message));
      debugPrint("[TCP CLIENT]: NEW MESSAGE (${message})");
    });
    await listener.asFuture<void>();
  }

  void pop_front() {
    _msg.removeAt(0);
  }

  List<Map<String, dynamic>> get messages {
    return _msg;
  }
}
