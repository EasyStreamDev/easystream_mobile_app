import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/SubPage/add_subtitle.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/Tools/globals.dart' as globals;

class SubtitlePage extends StatefulWidget {
  const SubtitlePage({Key? key}) : super(key: key);

  @override
  State<SubtitlePage> createState() => SubtitlePageState();
}

class SubtitlePageState extends State<SubtitlePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  final List<Padding> _widgetBoxListSubtitle = [];
  int nbrSubtitle = globals.subtitlelist.length;

  @override
  void initState() {
    for (int index = 0; index < nbrSubtitle; index++) {
      _widgetBoxListSubtitle.add(
        Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
            top: 15.0,
            bottom: 15.0,
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
                buildSubtitleName(index),
                buildSubtitleUUID(index),
              ],
            ),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: buildSubtitleTitle(),
                ),
                Column(children: _widgetBoxListSubtitle),
                const Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  /// Widget subtitle title RichText
  Widget buildSubtitleTitle() => const Padding(
        padding: EdgeInsets.only(top: 50, bottom: 30),
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
              text: globals.subtitlelist[index].name,
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
              text: globals.subtitlelist[index].uuid,
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
  Widget buildFloatingActionButton() => FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddSubtitlePage()));
        },
        backgroundColor: MyColor().myOrange,
        child: const Icon(Icons.add),
      );
}
