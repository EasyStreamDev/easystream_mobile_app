import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class VideoSource extends StatefulWidget {
  const VideoSource({Key? key}) : super(key: key);

  @override
  State<VideoSource> createState() => VideoSourceState();
}

class VideoSourceState extends State<VideoSource> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _videoSource = [];

  @override
  Widget build(BuildContext context) {
    final List<Padding> _widgetBoxListVideoSource = List.generate(
      2,
      (index) => Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 40.0,
          top: 40.0,
          // bottom: 15.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 60.0,
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
              buildVideoSourceName(index),
              buildMicsUUID(index),
            ],
          ),
        ),
      ),
    );
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
              buildVideoSourceScrollView(_widgetBoxListVideoSource),
            ],
          ),
        ),
          floatingActionButton: buildFloatingActionButton(),
      ),
    );
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
Widget buildVideoSourceName(int index) => RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Video Source : ',
          ),
          TextSpan(
            text: "Video Game Capture",
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
Widget buildMicsUUID(int index) => RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'uuid : ',
          ),
          TextSpan(
            text: "21825058-7a54-4057-bb17-a810c08f8db9",
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
Widget buildFloatingActionButton() => FloatingActionButton(
      onPressed: () {
        debugPrint(
            "---------------------- I QUIT THE VIDEOSOURCE PAGE ----------------------");
      },
      backgroundColor: MyColor().myOrange,
      child: const Icon(Icons.add),
    );
