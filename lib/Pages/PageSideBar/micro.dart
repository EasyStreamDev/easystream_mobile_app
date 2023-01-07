import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Elements/VolumeBar/volume_bar.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

List<bool> click = List.generate(100, (index) => false);

class MicroPage extends StatefulWidget {
  const MicroPage({Key? key}) : super(key: key);

  @override
  State<MicroPage> createState() => MicroPageState();
}

class MicroPageState extends State<MicroPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final List<Padding> widgetMicrophone = List.generate(
      6,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Column(
          children: <Widget>[
            Text(
              'Microphone ${index+1}',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 300,
                  child: MyVolumeBar(),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      click[index] = !click[index];
                      //TODO: Add mute action
                    });
                  },
                  icon: Icon((click[index] == false) ? Icons.mic : Icons.mic_off),
                  color: MyColor().myWhite,
                ),
              ],
            )
          ],
        ),
      )
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar: MyAppBar(
              title: "Micro Page", drawerScaffoldKey: drawerScaffoldKey),
          body: Scaffold(
            backgroundColor: MyColor().myGrey,
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: SingleChildScrollView(
              child: Column(
                children: widgetMicrophone
              ),
            ),
          )
      ),
    );
  }
}