import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:byte_util/byte_util.dart';
import 'package:flutter_charset_detector/flutter_charset_detector.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

class Client {
  late TcpSocketConnection _socketConnection;
  late Socket _socket;
  late String _ip;
  late int _port;
  late TcpClient _client;
  List<Map<String, dynamic>> _msg = [];
  String _tmpMesssage = "";
  // late Stream<String> _listener;

  Future<void> initialize(String ip, int port) async {
    _socket = await Socket.connect(ip, port);
    // TcpClient.debug = true;
    // _client = await TcpClient.connect(ip, port);
    // _socketConnection = TcpSocketConnection(ip, port);
    // _listener = utf8.decoder.bind(_socket);
    // _socket.listen((List<int> event) {
    //   String message = utf8.decode(event);
    //   // String message = String.fromCharCodes(utf8.decode(event)).trim();
    //   _msg.add(jsonDecode(message));
    //   print("[TCP CLIENT]: NEW MESSAGE (${message})");
    // });
    // launchClient();
  }

  void sendMessage(Map<String, dynamic> msg) {
    String toSend = JsonEncoder().convert(msg).trim();
    _socket.write(toSend);
  }

  void startClient() async {
    // _client.connectionStream.listen((event) {
    //   debugPrint("[TCP CLIENT]: NEW MESSAGE (${event})");
    // });

    // _client.stringStream.listen((event) {
    //   Map<String, dynamic> test = {"command": "getAllMics"};
    //   sendMessage(test);
    //   debugPrint("[TCP CLIENT]: NEW MESSAGE (${event})");
    // });
    // _socketConnection.enableConsolePrint(true);
    // if (await _socketConnection.canConnect(5000, attempts: 3))
    //   _socketConnection.connect(5000, readMessage);
  }

  void readMessage(String msg) {
    debugPrint("[TCP CLIENT]: NEW MESSAGE (${msg})");
  }

  void launchClient() async {
    bool doneOne = false;
    _socket.listen((event) {
      String message = utf8.decode(event);
      debugPrint("[TCP CLIENT]: NEW MESSAGE (${message})");
      if (!doneOne) {
        Map<String, dynamic> test = {"command": "getAllMics"};
        sendMessage(test);
        doneOne = true;
      }
    });
  }

  void pop_front() {
    _msg.removeAt(0);
  }

  List<Map<String, dynamic>> get messages {
    return _msg;
  }
}
