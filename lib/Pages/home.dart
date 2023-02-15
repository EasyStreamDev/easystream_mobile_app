import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/main.dart';

Future<void> getAllMics() async {
  Map<String, dynamic> msg = {"command": "getAllMics"};

  tcpClient.sendMessage(msg);
  await Future.delayed(Duration(seconds: 2));
  // while (tcpClient.messages.isEmpty);
}

String getText() {
  String textValue = "";
  TextEditingController _controller = TextEditingController();

  if (tcpClient.messages.isEmpty)
    return ("");
  else {
    var tmp = tcpClient.messages;
    if (tmp.isEmpty) return ("");
    var requestResult = tmp[0];
    tcpClient.pop_front();
    debugPrint("length is ${tmp.length}");
    debugPrint(requestResult.runtimeType.toString());
    requestResult.forEach((key, value) {
      debugPrint("Key : ${key} and value is ${value.runtimeType.toString()}");
    });
    // debugPrint(requestResult.forEach((key, value) { }))
    List<dynamic> mics = requestResult["data"]["mics"];
    mics.forEach((element) {
      Map<String, dynamic> tmp = element;
      debugPrint("tyyyyyyyyyyyyyyyype: ${tmp["micName"]}");
      textValue += tmp["micName"] + "\n";
    });
  }
  // Text result = new Text(textValue);
  return (textValue);
}

// {
//    {mics: [List],}
// }
//
//
//
//
//



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  final List<DropdownMenuItem<String>> _menuItems = [
    DropdownMenuItem(
      child: Text("getAllMics"),
      value: "getAllMics",
    )
  ];
  String _response = "";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColor().myGrey,
        appBar:
            MyAppBar(title: "Home Page", drawerScaffoldKey: drawerScaffoldKey),
        body: Scaffold(
          backgroundColor: MyColor().myGrey,
          key: drawerScaffoldKey,
          drawer: const NavigationDrawerWidget(),
          body: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 60.0),
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: MyColor().myOrange,
                          borderRadius: BorderRadius.circular(10)),
                      width: 200,
                      height: 100,
                      child: Image.asset(
                        'assets/images/logo_easystream_orange.png',
                      )),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor().myOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: MyColor().myOrange),
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              DropdownButton(
                  items: _menuItems,
                  value: _menuItems[0].value,
                  style: TextStyle(color: Colors.red),
                  onChanged: ((String? value) async => {
                        if (value!.contains("getAllMics")) {await getAllMics()},
                        setState(
                          () => {_response = getText()},
                        )
                      })),
              Text(
                _response,
                style: TextStyle(color: Colors.white),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
