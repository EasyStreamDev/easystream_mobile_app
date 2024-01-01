import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/PageSideBar/subtitle.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/Tools/globals.dart' as globals;
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

List<String> micNameList = List.empty();
List<String> textFieldsNameList = List.empty();
List<String> textFieldsUuidList = List.empty();

bool isLoading = true;

Future<void> getAllTextFields() async {
  Map<String, dynamic> msg = {"command": "/text-fields/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> getAllMics() async {
  Map<String, dynamic> msg = {"command": "/microphones/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> setSubtitles(
    String textFieldsUuid, int lenghtMicsArray, List<String> linkedMics, String language) async {
      debugPrint("------- language : " + language + " -------");
  Map<String, dynamic> msg = {
    "command": "/subtitles/set",
    "params": {
      "uuid": textFieldsUuid,
      "length": lenghtMicsArray,
      "linked_mics": linkedMics,
      "language": language,
    },
  };
  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
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
    if (requestResult["data"]["text_fields"] == null) {
      return ([]);
    }
    List<dynamic> textFields = requestResult["data"]["text_fields"];
    textFieldsNameList = List.generate(textFields.length, (index) => "");
    textFieldsUuidList = List.generate(textFields.length, (index) => "");
    for (int i = 0; i < textFields.length; i++) {
      textFieldsNameList[i] = textFields[i]["name"];
      textFieldsUuidList[i] = textFields[i]["uuid"];
    }
    return (textFields);
  }
}

List<dynamic> getMics() {
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
    if (requestResult["data"]["mics"] == null) {
      return ([]);
    }
    List<dynamic> mics = requestResult["data"]["mics"];
    micNameList = List.generate(requestResult.length - 1, (index) => "null");
    for (int i = 0; i < mics.length; i++) {
      micNameList[i] = mics[i]["micName"];
    }
    return (mics);
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
  List<dynamic> _mics = [];

  String dropdownTextFields = "";
  List<String> tmpNameTextFields = [];
  String dropdownMics = "";
  List<String> tmpNameMics = [];
  String dropdownLanguage = "fr";
  List<String> tmpNameLanguage = [
    "fr",
    "es",
    "en",
    "de",
  ];

  List<String> micNameListToSend = [];

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataTextFields();
    _getDataMics();
    _getDataLanguage();
  }

  _getDataTextFields() async {
    await getAllTextFields();
    if (mounted) {
      setState(
        () => _textFields = getTextFields(),
      );
      if (_textFields.isNotEmpty) {
        dropdownTextFields = textFieldsNameList[0];
        for (int i = 0; i < textFieldsNameList.length; i++) {
          tmpNameTextFields.add(textFieldsNameList[i]);
        }
      }
    }
  }

  _getDataMics() async {
    await getAllMics();

    if (mounted) {
      setState(
        () => _mics = getMics(),
      );
      if (_mics.isNotEmpty) {
        dropdownMics = micNameList[0];
        for (int i = 0; i < micNameList.length; i++) {
          tmpNameMics.add(micNameList[i]);
        }
      }
      isLoading = false;
    }
  }

  _getDataLanguage() {
    if (mounted) {
      
    }
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
            elevation: 0,
            backgroundColor: MyColor().backgroundAppBar,
            title: Text("Add Subtitle",
                style: TextStyle(color: MyColor().myWhite)),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: MyColor().myWhite,
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Divider(
                height: 1,
                color: MyColor().myOrange,
                thickness: 1,
              ),
              const SizedBox(
                height: 150,
              ),
              buildSelectTextFieldsTitle(),
              buildSelectTextFields(),
              const SizedBox(
                height: 50,
              ),
              // buildSelectMicsTitle(),
              buildSelectMics(),
              const SizedBox(
                height: 50,
              ),
              buildSelectLanguageTitle(),
              buildSelectLanguage(),
            ],
          ),
          floatingActionButton: buildFloatingSubtitle(),
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
            elevation: 0,
            backgroundColor: MyColor().backgroundAppBar,
            title: Text("Add Subtitle",
                style: TextStyle(color: MyColor().myWhite)),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: MyColor().myWhite,
              ),
            ),
          ),
          body: Scaffold(
            backgroundColor: MyColor().myGrey,
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: Stack(
              children: <Widget>[
                Divider(
                  height: 1,
                  color: MyColor().myOrange,
                  thickness: 1,
                ),
                const Center(
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
            elevation: 0,
            backgroundColor: MyColor().backgroundAppBar,
            title: Text("Add Subtitle",
                style: TextStyle(color: MyColor().myWhite)),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: MyColor().myWhite,
              ),
            ),
          ),
          body: Scaffold(
            backgroundColor: MyColor().myGrey,
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: Stack(
              children: <Widget>[
                Divider(
                  height: 1,
                  color: MyColor().myOrange,
                  thickness: 1,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
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
                if (mounted) {
                  setState(
                    () {
                      dropdownTextFields = selectedValue!;
                      tmpNameTextFields.remove(
                        selectedValue.toString(),
                      );
                      tmpNameTextFields.insert(
                        0,
                        selectedValue.toString(),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      );

  /// Widget select mics title Row
  Widget buildSelectMicsTitle() => const Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select a Mic :",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );

  /// Widget select mics Row
  Widget buildSelectMics() => Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: MyColor().myOrange,
                    width: 2.0,
                  ),
                ),
              ),
              child: MultiSelectDialogField<String>(
                items: micNameList
                    .map((micNameList) =>
                        MultiSelectItem(micNameList, micNameList))
                    .toList(),
                initialValue: micNameListToSend,
                onConfirm: (values) {
                  if (mounted) {
                    setState(() {
                      micNameListToSend = values;
                    });
                  }
                },
                // style
                title: const Text(
                  "Select a Mic",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                buttonText: const Text(
                  "Select a Mic",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                buttonIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xfff56f28),
                ),
                backgroundColor: MyColor().myGrey,
                selectedColor: MyColor().myOrange,
                selectedItemsTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 16),
                itemsTextStyle:
                    const TextStyle(color: Colors.white, fontSize: 16),
                unselectedColor: MyColor().myWhite,
                dialogHeight: 150,
              ),
            ),
          ),
        ],
      );

  /// Widget select text fields title Row
  Widget buildSelectLanguageTitle() => const Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select a Language :",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );

  /// Widget select text fields Row
  Widget buildSelectLanguage() => Row(
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
              value: dropdownLanguage,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: MyColor().myOrange,
              items: tmpNameLanguage.map(
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
                if (mounted) {
                  setState(
                    () {
                      dropdownLanguage = selectedValue!;
                      tmpNameLanguage.remove(
                        selectedValue.toString(),
                      );
                      tmpNameLanguage.insert(
                        0,
                        selectedValue.toString(),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      );

  /// Widget add subtitle floating action button FloatingActionButton
  Widget buildFloatingSubtitle() => Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColor().myOrange, width: 1.0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton(
          backgroundColor: MyColor().backgroundCards,
          child: Icon(
            Icons.save,
            color: MyColor().myWhite,
          ),
          onPressed: () async {
            globals.Subtitle subtitle = globals.Subtitle();
            if (micNameListToSend.isNotEmpty && mounted) {
              for (int i = 0; i < textFieldsNameList.length; i++) {
                if (dropdownTextFields == textFieldsNameList[i]) {
                  subtitle.uuid = textFieldsUuidList[i];
                }
              }
              subtitle.length = micNameListToSend.length;
              subtitle.linkedMics = micNameListToSend;
              subtitle.language = dropdownLanguage;
              LoadingOverlay.of(context).show();
              await setSubtitles(
                  subtitle.uuid, subtitle.length, subtitle.linkedMics, subtitle.language);
              LoadingOverlay.of(context).hide();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const LoadingOverlay(child: SubtitlePage())));
            } else {
              buildShowDialogError("You have to select a mic");
            }
          },
        ),
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
