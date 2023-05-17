import 'package:eip_test/Pages/login.dart';
import 'package:eip_test/Tools/color_tool.dart';
import 'package:flutter/material.dart';
import 'Client/client.dart';

import 'Styles/color.dart';

Client tcpClient = Client();

void main() {
  runApp(const MyApp());
}

Future<bool> createTcpClient(String ipAddress) async {
  bool valueReturn = false;
  debugPrint(ipAddress);
  // await tcpClient.initialize("172.16.27.211", 47920).then((value) { // OOP
  await tcpClient.initialize("192.168.0.17", 47920).then((value) { // house
  // await tcpClient.initialize("172.16.7.214", 47920).then((value) { // operating system
    tcpClient.startClient();
    valueReturn = value;
  });
  return valueReturn;
  // return true; 
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
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
