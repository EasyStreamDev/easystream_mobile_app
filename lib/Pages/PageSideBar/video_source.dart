import 'dart:async';
import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/SubPage/add_video_source.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';

List<String> micsUuidList = List.empty();
List<List<String>> videoSourceUuidList = List.empty();

bool isLoading = true;

Future<void> getAllMtdsis() async {
  Map<String, dynamic> msg = {"command": "/mtdsis/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

class VideoSource extends StatefulWidget {
  const VideoSource({Key? key}) : super(key: key);

  @override
  State<VideoSource> createState() => VideoSourceState();
}

List<dynamic> getMtdsis() {
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
    if (requestResult["data"]["links"] == null) {
      return ([]);
    }
    List<dynamic> mtdsis = requestResult["data"]["links"];
    micsUuidList = List.generate(mtdsis.length, (index) => "");
    videoSourceUuidList = List.generate(mtdsis.length, (index) => []);
    for (int i = 0; i < mtdsis.length; i++) {
      micsUuidList[i] = mtdsis[i]["mic_id"];
      videoSourceUuidList[i] =
          List.generate(mtdsis[i]["display_sources_ids"].length, (index) => "");
      for (int j = 0; j < mtdsis[i]["display_sources_ids"].length; j++) {
        videoSourceUuidList[i][j] = mtdsis[i]["display_sources_ids"][j];
      }
    }
    return (mtdsis);
  }
}

class VideoSourceState extends State<VideoSource> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _mtdsis = [];

  StreamSubscription<int>? _streamSubscription;
  final StreamController<int> _streamController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataMtdsis();
    _runBackgroundTask();
  }

  _getDataMtdsis() async {
    await getAllMtdsis();

    if (mounted) {
      setState(
        () => _mtdsis = getMtdsis(),
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
            builder: (context) => const LoadingOverlay(child: VideoSource())));
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
        "---------------------- I QUIT THE VIDEO SOURCE PAGE ----------------------");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Padding> _widgetBoxListVideoSource = List.generate(
      _mtdsis.length,
      (index) => Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 40.0,
          top: 40.0,
          // bottom: 15.0,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          height: 130.0,
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
              buildMicUUID(index),
              // buildMicName(index),
              buildVideoSourceName(index),
            ],
          ),
        ),
      ),
    );
    if (_widgetBoxListVideoSource.isNotEmpty && !isLoading) {
      // After loading with data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar: MyAppBar(
              title: "VideoSource", drawerScaffoldKey: drawerScaffoldKey),
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
                buildVideoSourceScrollView(_widgetBoxListVideoSource),
              ],
            ),
          ),
          floatingActionButton: buildFloatingActionButton(context),
        ),
      );
    } else if (_widgetBoxListVideoSource.isEmpty && !isLoading) {
      // After loading without data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar: MyAppBar(
              title: "VideoSource", drawerScaffoldKey: drawerScaffoldKey),
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
                    "No Video Source to load",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: buildFloatingActionButton(context),
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
          appBar: MyAppBar(
              title: "VideoSource", drawerScaffoldKey: drawerScaffoldKey),
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
          floatingActionButton: buildFloatingActionButton(context),
        ),
      );
    }
  }
}

/// Widget videoSource scroll view SingleChildScrollView
///
/// @param [_widgetBoxListVideoSource] is the list of videoSource
Widget buildVideoSourceScrollView(List<Padding> _widgetBoxListVideoSource) =>
    SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(children: _widgetBoxListVideoSource),
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 40),
          ),
        ],
      ),
    );

/// Widget videoSource name RichText
Widget buildMicName(int index) => RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Mic : ',
          ),
          TextSpan(
            text: "Desktop Audio",
            style: TextStyle(
              color: MyColor().myOrange,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

/// Widget videoSource name RichText
Widget buildVideoSourceName(int index) => RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Video Source : \n',
          ),
          for (int i = 0; i < videoSourceUuidList[index].length; i++)
            TextSpan(
              text: videoSourceUuidList[index][i] + "\n",
              style: TextStyle(
                color: MyColor().myOrange,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );

/// Widget Mics UUID RichText
Widget buildMicUUID(int index) => RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Mic : \n',
          ),
          TextSpan(
            text: micsUuidList[index] + "\n",
            style: TextStyle(
              color: MyColor().myOrange,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

/// Widget videoSource floating action button FloatingActionButton
Widget buildFloatingActionButton(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: MyColor().myOrange, width: 1.0),
      borderRadius: BorderRadius.circular(30),
    ),
    child: FloatingActionButton(
      backgroundColor: MyColor().backgroundCards,
      child: Icon(
        Icons.add,
        color: MyColor().myWhite,
      ),
      onPressed: () {
        debugPrint(
            "---------------------- I QUIT THE VIDEOSOURCE PAGE ----------------------");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                const LoadingOverlay(child: AddVideoSourcePage())));
      },
    ));
