import 'package:eip_test/Pages/login.dart';
import 'package:eip_test/Tools/color_tool.dart';
import 'package:flutter/material.dart';

import 'Styles/color.dart';

void main() {
  runApp(const MyApp());
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