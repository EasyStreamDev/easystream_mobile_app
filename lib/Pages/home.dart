import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar:
            MyAppBar(title: "Home Page", drawerScaffoldKey: drawerScaffoldKey),
        body: Scaffold(
          backgroundColor: MyColor().backgroundApp,
          key: drawerScaffoldKey,
          drawer: const NavigationDrawerWidget(),
          body: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Divider(
                height: 1,
                color: MyColor().myOrange,
                thickness: 1,
              ),
              buildLogo(),
              buildCompressorButton(),
              const SizedBox(height: 12),
              buildActionReactionButton(),
              const SizedBox(height: 12),
              buildSubtitleButton(),
              const SizedBox(height: 12),
              buildVideoSourceButton(),
            ],
          )),
        ),
      ),
    );
  }

  /// Widget logo
  Widget buildLogo() => Padding(
        padding: const EdgeInsets.only(top: 60.0, bottom: 60.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: MyColor().backgroundCards,
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: MyColor().myOrange),
              ),
            width: 200,
            height: 100,
            child: Image.asset(
              'assets/images/logo_easystream_transparent.png',
            ),
          ),
        ),
      );

  /// Widget CompressorButton
  Widget buildCompressorButton() => SizedBox(
        width: 200.0,
        height: 100.0,
        child: ElevatedButton.icon(
          icon : Icon(
            Icons.mic,
            color: MyColor().myWhite,
          ),
          label: Text(
            "Compressor",
            style: TextStyle(color: MyColor().myWhite, fontSize: 15),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(MyColor().backgroundCards),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: MyColor().myOrange, width: 1)),
          ),
          onPressed: () async {},
        ),
      );

  /// Widget ActionReactionButton
  Widget buildActionReactionButton() => SizedBox(
        width: 200.0,
        height: 100.0,
        child: ElevatedButton.icon(
          icon : Icon(
            Icons.add_reaction,
            color: MyColor().myWhite,
          ),
          label: Text(
            "Action & Reaction",
            style: TextStyle(color: MyColor().myWhite, fontSize: 15),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(MyColor().backgroundCards),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: MyColor().myOrange, width: 1)),
          ),
          onPressed: () async {},
        ),
      );

  /// Widget ActionReactionButton
  Widget buildSubtitleButton() => SizedBox(
        width: 200.0,
        height: 100.0,
        child: ElevatedButton.icon(
          icon : Icon(
            Icons.subtitles,
            color: MyColor().myWhite,
          ),
          label: Text(
            "Action & Reaction",
            style: TextStyle(color: MyColor().myWhite, fontSize: 15),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(MyColor().backgroundCards),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: MyColor().myOrange, width: 1)),
          ),
          onPressed: () async {},
        ),
      );

  /// Widget ActionReactionButton
  Widget buildVideoSourceButton() => SizedBox(
        width: 200.0,
        height: 100.0,
        child: ElevatedButton.icon(
          icon : Icon(
            Icons.video_camera_front_outlined,
            color: MyColor().myWhite,
          ),
          label: Text(
            "Action & Reaction",
            style: TextStyle(color: MyColor().myWhite, fontSize: 15),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(MyColor().backgroundCards),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: MyColor().myOrange, width: 1)),
          ),
          onPressed: () async {},
        ),
      );
}
