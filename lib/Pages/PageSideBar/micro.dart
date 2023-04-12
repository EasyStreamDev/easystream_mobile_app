import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Elements/VolumeBar/volume_bar.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';

List<bool> micClickList = List.generate(100, (index) => false);
List<String> micNameList = List.generate(100, (index) => "null");
List<double> micLevelList = List.generate(100, (index) => 0);


Future<void> getAllMics() async {
  Map<String, dynamic> msg = {"command": "getAllMics"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  // while (tcpClient.messages.isEmpty) {}
}

Future<void> setAllMics(List<dynamic> _mics) async {
  for (int i = 0; i < _mics.length; i ++) {
    Map<String, dynamic> msg = {
      "command": "setMicLevel",
      "params": {
        "isActive": micClickList[i],
        "level": micLevelList[i],
        "micName": micNameList[i],
      }
    };
    tcpClient.sendMessage(msg);
  }
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
}

List<dynamic> getMics() {
  if (tcpClient.messages.isEmpty) {
    debugPrint("There has been an error: tcp is empty");
    return ([]);
  } else {
    debugPrint("------tcpClient.messages-------");
    debugPrint("tcpClient.messages : " + tcpClient.messages.toString());
    var tmp = tcpClient.messages;
    debugPrint("-------------tmp---------------");
    debugPrint("tmp : " + tmp.toString());
    if (tmp.isEmpty) {
      debugPrint("There has been an error: tmp is empty");
      return ([]);
    }
    debugPrint("------------tmp[0]-------------");
    debugPrint("tmp[0] : " + tmp[0].toString());
    debugPrint("------------tmp[i]-------------");
    for (int i = 0; i < tmp.length; i ++) {
      debugPrint("tmp[" + i.toString() + "] : " + tmp[i].toString());
    }
    var requestResult = tmp[0];
    if (tmp[0]["data"] == null) {
      debugPrint("There has been an error: couldn't get the last data");
      requestResult = tmp[1];
    }
    tcpClient.pop_front();
    // tcpClient.messages.clear();
    if (requestResult["data"] == null) {
      debugPrint("There has been an error: requestResult is empty");
      return ([]);
    }
    List<dynamic> mics = requestResult["data"]["mics"];
    for (int i = 0; i < mics.length; i++) {
      micClickList[i] = mics[i]["isActive"];
      micNameList[i] = mics[i]["micName"];
      micLevelList[i] = mics[i]["level"];
    }
    return (mics);
  }
}

class MicroPage extends StatefulWidget {
  const MicroPage({Key? key}) : super(key: key);

  @override
  State<MicroPage> createState() => MicroPageState();
}

class MicroPageState extends State<MicroPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _mics = [];

  @override
  void initState() {
    super.initState();

    _getDataMics();
  }

  _getDataMics() async {
    await getAllMics();

    setState(
      () => {_mics = getMics()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Padding> widgetMicrophone = List.generate(
        _mics.length,
        (index) => Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Column(
                children: <Widget>[
                  Text(
                    micNameList[index],
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 300,
                        child: MyVolumeBar(
                          level: micLevelList[index],
                          onChange: (newVal) {
                            setState(() {micLevelList[index] = newVal;});
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            micClickList[index] = !micClickList[index];
                          });
                        },
                        icon: Icon(
                            (micClickList[index] == true) ? Icons.mic : Icons.mic_off),
                        color: MyColor().myWhite,
                      ),
                    ],
                  )
                ],
              ),
            ));

    if (_mics.isNotEmpty) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: MyColor().myGrey,
            appBar: MyAppBar(
                title: "Compressor", drawerScaffoldKey: drawerScaffoldKey),
            body: Scaffold(
              backgroundColor: MyColor().myGrey,
              key: drawerScaffoldKey,
              drawer: const NavigationDrawerWidget(),
              body: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Column(children: widgetMicrophone),
                        const Padding(
                          padding: EdgeInsets.only(top: 40, bottom: 40),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: 150.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await setAllMics(_mics);
                                },
                                child: const Text("Save changes"),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar: MyAppBar(
              title: "Compressor", drawerScaffoldKey: drawerScaffoldKey),
          body: Scaffold(
            backgroundColor: MyColor().myGrey,
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: const Center(
              child: CircularProgressIndicator()
              ),
          ),
        ),
      );
    }
  }
}
