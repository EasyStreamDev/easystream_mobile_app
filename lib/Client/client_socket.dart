import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tcp_client_dart/tcp_client_dart.dart';

class Client {
  late Socket _socket;
  late TcpClient _client;
  final List<Map<String, dynamic>> _msg = [];
  bool isBroadcast = false;
  bool isCompressor = false;
  bool isArea = false;
  bool isSubtitle = false;

  Future<bool> initialize(String ip, int port) async {
    TcpClient.debug = false;
    try {
      _client = await TcpClient.connect(ip, port,
          timeout: const Duration(seconds: 10));
      return true;
    } catch (e) {
      debugPrint("Couldn't initialize connection to OBS : " + e.toString());
      return false;
    }
  }

  void sendMessage(Map<String, dynamic> msg) {
    String toSend = const JsonEncoder().convert(msg).trim() + "\r\n";
    try {
      _client.write(toSend);
    } catch (e) {
      debugPrint("Couldn't send a message to OBS : " + e.toString());
    }
  }

  Future<bool> startClient() async {
    try {
      _client.connectionStream.listen((event) {
        debugPrint("[TCP CLIENT]: NEW MESSAGE ($event)");
      });
      _client.stringStream.listen((event) {
        if (!event.contains("connected")) {
          dynamic request = jsonDecode(event);
          if (request["message"] == "BROADCAST") {
            debugPrint("request[message] : " + request["message"].toString());
            debugPrint("---------- "+ request["data"]["type"].toString() + " ----------");
            if (request["data"]["type"] == "compressorSettingsChanged") {
              isCompressor = true;
            }
            if (request["data"]["type"] == "areasChanged") {
              isArea = true;
            }
            if (request["data"]["type"] == "subtitlesSettingsChanged") {
              isSubtitle = true;
            }
            isBroadcast = true;
          } else {
            _msg.add(request);
          }
          debugPrint("adding message");
        }
        debugPrint("[TCP CLIENT]: NEW MESSAGE ($event)");
      });
      return true;
    } catch (e) {
      debugPrint("Couldnt start client connction to OBS : " + e.toString());
      return false;
    }
  }

  void readMessage(String msg) {
    debugPrint("[TCP CLIENT]: NEW MESSAGE ($msg)");
  }

  void launchClient() async {
    var listener = _socket.listen((event) {
      String message = utf8.decode(event);
      _msg.add(jsonDecode(message));
      debugPrint("[TCP CLIENT]: NEW MESSAGE ($message)");
    });
    await listener.asFuture<void>();
  }

  // ignore: non_constant_identifier_names
  void pop_front() {
    _msg.removeAt(0);
  }

  List<Map<String, dynamic>> get messages {
    return _msg;
  }
}
