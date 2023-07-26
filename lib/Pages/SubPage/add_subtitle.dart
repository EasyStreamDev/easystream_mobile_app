import 'dart:io';

import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/PageSideBar/subtitle.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/Tools/globals.dart' as globals;

List<String> textFieldsNameList = List.empty();
List<String> textFieldsUUIDList = List.empty();
bool isLoading = true;

Future<void> getAllTextFields() async {
  Map<String, dynamic> msg = {"command": "getAllTextFields"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

List<dynamic> getTextFields() {
  if (tcpClient.messages.isEmpty) {
    debugPrint("There has been an error: tcp is empty");
    return ([]);
  } else {
    var tmp = tcpClient.messages;
    if (tmp.isEmpty) {
      debugPrint("There has been an error: tmp is empty");
      return ([]);
    }
    var requestResult = tmp[0];
    if (tmp[0]["data"] == null) {
      debugPrint("There has been an error: couldn't get the last data");
      requestResult = tmp[1];
    }
    tcpClient.pop_front();
    if (requestResult["data"] == null) {
      debugPrint("There has been an error: requestResult is empty");
      return ([]);
    }
    List<dynamic> textFields = requestResult["data"]["text_fields"];
    textFieldsNameList = List.generate(textFields.length, (index) => "");
    textFieldsUUIDList = List.generate(textFields.length, (index) => "");
    for (int i = 0; i < textFields.length; i++) {
      textFieldsNameList[i] = textFields[i]["name"];
      textFieldsUUIDList[i] = textFields[i]["uuid"];
    }
    return (textFields);
  }
}

class AddSubtitlePage extends StatefulWidget {
  const AddSubtitlePage({Key? key}) : super(key: key);

  @override
  State<AddSubtitlePage> createState() => AddSubtitlePageState();
}

class AddSubtitlePageState extends State<AddSubtitlePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _textFields = [];
  String dropdownTextFields = "";
  List<String> tmpNameTextFields = [];

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataTextFields();
  }

  _getDataTextFields() async {
    await getAllTextFields();

    setState(
      () => _textFields = getTextFields(),
    );
    dropdownTextFields = textFieldsNameList[0];
    for (int i = 0; i < textFieldsNameList.length; i++) {
      tmpNameTextFields.add(textFieldsNameList[i]);
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_textFields.isNotEmpty && !isLoading) {
      // After loading with data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar: AppBar(
            title: const Text("Add Subtitle"),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
            children: <Widget>[
              const SizedBox(
                height: 250,
              ),
              buildSelectTextFieldsTitle(),
              buildSelectTextFields(),
            ],
          ),
          floatingActionButton: buildFloatingActionButton(),
        ),
      );
    } else if (_textFields.isEmpty && !isLoading) {
      // After loading without data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Subtitle"),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Scaffold(
            backgroundColor: MyColor().myGrey,
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: const Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    "No Subtitle to load",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Loading
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar: AppBar(
            title: const Text("Add Subtitle"),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Scaffold(
            backgroundColor: MyColor().myGrey,
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }
  }

  /// Widget select text fields title Row
  Widget buildSelectTextFieldsTitle() => const Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select a Text Field :",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );

  /// Widget select text fields Row
  Widget buildSelectTextFields() => Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: DropdownButton(
              underline: Container(
                height: 2,
                color: MyColor().myOrange,
              ),
              dropdownColor: MyColor().myGrey,
              value: dropdownTextFields,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: MyColor().myOrange,
              items: tmpNameTextFields.map(
                (items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                },
              ).toList(),
              onChanged: (String? selectedValue) {
                setState(() {
                  dropdownTextFields = selectedValue!;
                  tmpNameTextFields.remove(
                    selectedValue.toString(),
                  );
                  tmpNameTextFields.insert(
                    0,
                    selectedValue.toString(),
                  );
                });
              },
            ),
          )
        ],
      );

  /// Widget add subtitle floating action button FloatingActionButton
  Widget buildFloatingActionButton() => FloatingActionButton(
        onPressed: () {
          bool error = false;
          globals.Subtitle subtitle = globals.Subtitle();
          for (int i = 0; i < globals.subtitlelist.length; i++) {
            if (globals.subtitlelist[i].name == dropdownTextFields) {
              buildShowDialogError(
                  "Subtitles are already activated on that Text Field");
              error = true;
            }
          }
          if (error == false) {
            subtitle.name = dropdownTextFields;
            subtitle.uuid = "";
            for (int i = 0; i < textFieldsNameList.length; i++) {
              if (dropdownTextFields == textFieldsNameList[i]) {
                subtitle.uuid = textFieldsUUIDList[i];
              }
            }
            debugPrint("name : " + subtitle.name);
            debugPrint("uuid : " + subtitle.uuid);
            globals.subtitlelist.add(subtitle);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SubtitlePage()));
          }
        },
        backgroundColor: MyColor().myOrange,
        child: const Icon(Icons.save),
      );

  /// Widget Future show dialog Error
  ///
  /// @param [message] to be printed
  Future buildShowDialogError(String message) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Error",
              style: TextStyle(color: MyColor().myOrange),
            ),
            content: Text(
              message,
              style: TextStyle(color: MyColor().myOrange),
            ),
            backgroundColor: MyColor().myGrey,
          );
        },
      );
}
