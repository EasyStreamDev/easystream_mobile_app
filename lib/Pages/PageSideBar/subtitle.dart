import 'dart:async';

import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/SubPage/add_subtitle.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';

List<String> textFieldsUuidList = List.empty();
List<String> textFieldsNameList = List.empty();
List<List<String>> linkedMicsList = [];

Future<void> getAllSubtitlesSettings() async {
  Map<String, dynamic> msg = {"command": "/subtitles/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

List<dynamic> getSubtitlesSettings() {
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
    List<dynamic> subtitlesSettings = requestResult["data"]["text_fields"];
    textFieldsUuidList = List.generate(subtitlesSettings.length, (index) => "");
    textFieldsNameList = List.generate(subtitlesSettings.length, (index) => "");
    linkedMicsList = List.generate(subtitlesSettings.length, (index) => []);
    for (int i = 0; i < subtitlesSettings.length; i++) {
      textFieldsUuidList[i] = subtitlesSettings[i]["uuid"];
      textFieldsNameList[i] = subtitlesSettings[i]["name"];
      linkedMicsList[i] = List.generate(
          subtitlesSettings[i]["linked_mics"].length, (index) => "");
      for (int j = 0; j < subtitlesSettings[i]["linked_mics"].length; j++) {
        linkedMicsList[i][j] = subtitlesSettings[i]["linked_mics"][j];
      }
    }
    return (subtitlesSettings);
  }
}

class SubtitlePage extends StatefulWidget {
  const SubtitlePage({Key? key}) : super(key: key);

  @override
  State<SubtitlePage> createState() => SubtitlePageState();
}

class SubtitlePageState extends State<SubtitlePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _subtitlesSettings = [];

  StreamSubscription<int>? _streamSubscription;
  final StreamController<int> _streamController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataSubtitlesSettings();
    _runBackgroundTask();
  }

  _getDataSubtitlesSettings() async {
    await getAllSubtitlesSettings();

    if (mounted) {
      setState(
        () => _subtitlesSettings = getSubtitlesSettings(),
      );
    }
    isLoading = false;
  }

  _runBackgroundTask() async {
    _streamSubscription = Stream.periodic(const Duration(seconds: 1), (count) {
      if (tcpClient.isBroadcast && tcpClient.isSubtitle) {
        _streamController.add(count);
        isLoading = true;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoadingOverlay(child: SubtitlePage())));
        tcpClient.isBroadcast = false;
        tcpClient.isSubtitle = false;
      }
      return count;
    }).listen((count) {});
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamController.close();
    debugPrint(
        "---------------------- I QUIT THE SUBTITLE PAGE ----------------------");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Padding> _widgetBoxListSubtitle = List.generate(
      _subtitlesSettings.length,
      (index) => Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 40.0,
          top: 80.0,
          // bottom: 15.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 80.0,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: MyColor().myWhite,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: <Widget>[
              buildSubtitleName(index),
              buildSubtitleUUID(index),
              buildSubtitleLinkedMics(index),
            ],
          ),
        ),
      ),
    );
    if (_subtitlesSettings.isNotEmpty && !isLoading) {
      // After loading with data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar:
              MyAppBar(title: "Subtitle", drawerScaffoldKey: drawerScaffoldKey),
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
                buildSubtitleTitle(),
                buildSubtitleScrollView(_widgetBoxListSubtitle),
              ],
            ),
          ),
          floatingActionButton: buildFloatingActionButton(),
        ),
      );
    } else if (_subtitlesSettings.isEmpty && !isLoading) {
      // After loading without data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar:
              MyAppBar(title: "Subtitle", drawerScaffoldKey: drawerScaffoldKey),
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
          floatingActionButton: buildFloatingActionButton(),
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
          appBar:
              MyAppBar(title: "Subtitle", drawerScaffoldKey: drawerScaffoldKey),
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
              )),
        ),
      );
    }
  }

  /// Widget subtitle scroll view SingleChildScrollView
  ///
  /// @param [_widgetBoxListSubtitle] is the list of Subtitle
  Widget buildSubtitleScrollView(List<Padding> _widgetBoxListSubtitle) =>
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(children: _widgetBoxListSubtitle),
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 40),
            ),
          ],
        ),
      );

  /// Widget subtitle title RichText
  Widget buildSubtitleTitle() => const Padding(
        padding: EdgeInsets.only(top: 30, bottom: 30, left: 25),
        child: Text(
          "Subtitles Text Fields activated :",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
      );

  /// Widget subtitle name RichText
  Widget buildSubtitleName(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Text Field : ',
            ),
            TextSpan(
              text: textFieldsNameList[index],
              style: TextStyle(
                color: MyColor().myOrange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  /// Widget subtitle title RichText
  Widget buildSubtitleUUID(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'uuid : ',
            ),
            TextSpan(
              text: textFieldsUuidList[index],
              style: TextStyle(
                color: MyColor().myOrange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  /// Widget subtitle title RichText
  Widget buildSubtitleLinkedMics(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'linked_mics : ',
            ),
            for (int i = 0; i < linkedMicsList[index].length; i++)
              TextSpan(
                text: linkedMicsList[index][i] + " | ",
                style: TextStyle(
                  color: MyColor().myOrange,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      );

  /// Widget subtitle floating action button FloatingActionButton
  Widget buildFloatingActionButton() => Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: MyColor().myOrange, width: 1.0), // Set border color and width
          borderRadius: BorderRadius.circular(
              30), // Optional: Set border radius for rounded corners
        ),
        child: FloatingActionButton(
          backgroundColor: MyColor().backgroundCards,
          child: Icon(
            Icons.add,
            color: MyColor().myWhite,
          ),
          onPressed: () {
            _streamSubscription?.cancel();
            _streamController.close();
            debugPrint(
                "---------------------- I QUIT THE SUBTITLE PAGE ----------------------");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const LoadingOverlay(child: AddSubtitlePage())));
          },
        ),
      );
}
