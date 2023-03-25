import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Elements/VolumeBar/volume_bar.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';

List<bool> click = List.generate(100, (index) => false);

Future<void> getAllMics() async {
  Map<String, dynamic> msg = {"command": "getAllMics"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  // while (tcpClient.messages.isEmpty);
}

Future<void> setAllMics() async {
  Map<String, dynamic> msg = {
    "isActive": true,
    "level": 5,
    "micName": "Mic/Aux",
  };

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  // while (tcpClient.messages.isEmpty);
}

List<dynamic> getMics() {
  if (tcpClient.messages.isEmpty) {
    return ([]);
  } else {
    var tmp = tcpClient.messages;
    if (tmp.isEmpty) return ([]);
    var requestResult = tmp[0];
    tcpClient.pop_front();
    List<dynamic> mics = requestResult["data"]["mics"];
    for (int i = 0; i < mics.length; i++) {
      click[i] = mics[i]["isActive"];
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
                    '${_mics[index]["micName"]}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 300,
                        child: MyVolumeBar(
                          mics: _mics,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            click[index] = !click[index];
                          });
                        },
                        icon: Icon(
                            (click[index] == true) ? Icons.mic : Icons.mic_off),
                        color: MyColor().myWhite,
                      ),
                    ],
                  )
                ],
              ),
            ));
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
                Expanded(
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
                                await setAllMics();
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
  }
}
