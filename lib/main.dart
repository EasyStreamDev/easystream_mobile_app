import 'package:eip_test/Pages/login.dart';
import 'package:eip_test/Tools/color_tool.dart';
import 'package:flutter/material.dart';
import 'Client/client.dart';

import 'Styles/color.dart';

Client tcpClient = Client();

void main() {
  runApp(const MyApp());
}

Future<bool> createTcpClient() async {
  bool valueReturn = false;

  //tcpClient.initialize("172.16.25.147", 47920).then((value) {
  await tcpClient.initialize("192.168.0.17", 47920).then((value) {
    tcpClient.startClient();
    valueReturn = value;
  });
  return valueReturn;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: buildMaterialColor(MyColor().myOrange),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
