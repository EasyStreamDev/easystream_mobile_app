import 'package:eip_test/Pages/login.dart';
import 'package:eip_test/Tools/color_tool.dart';
import 'package:flutter/material.dart';
import 'Client/client.dart';

import 'Styles/color.dart';

Client tcpClient = new Client();

void main() {
  runApp(MyApp());
}

void createTcpClient() async {
  tcpClient.initialize("192.168.0.7", 47920).then((value) {
    tcpClient.startClient();
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // final Client _client = new Client();

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
