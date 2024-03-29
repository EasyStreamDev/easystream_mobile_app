import 'dart:async';

import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Elements/VolumeBar/volume_bar.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';

List<bool> micClickList = List.empty();
List<String> micNameList = List.empty();
List<double> micLevelList = List.empty();
List<MyVolumeBar> volumeBarList = List.empty();
bool isLoading = true;

Future<void> getAllMics() async {
  tcpClient.messages.clear();
  Map<String, dynamic> msg = {"command": "/microphones/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> setAllMics(List<dynamic> _mics) async {
  for (int i = 0; i < _mics.length; i++) {
    Map<String, dynamic> msg = {
      "command": "/microphones/auto-leveler/set",
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
    List<dynamic> mics = requestResult["data"]["mics"];
    micClickList = List.generate(requestResult.length, (index) => false);
    micNameList = List.generate(requestResult.length, (index) => "null");
    micLevelList = List.generate(requestResult.length, (index) => 0);
    volumeBarList = List.generate(requestResult.length,
        (index) => MyVolumeBar(level: 0, onChange: const {}));
    for (int i = 0; i < mics.length; i++) {
      micClickList[i] = mics[i]["isActive"];
      micNameList[i] = mics[i]["micName"];
      micLevelList[i] = mics[i]["level"];
      volumeBarList[i] = MyVolumeBar(
          level: micLevelList[i],
          onChange: (newVal) {
            micLevelList[i] = newVal;
          });
    }
    return (mics);
  }
}

class CompressorPage extends StatefulWidget {
  const CompressorPage({Key? key}) : super(key: key);

  @override
  State<CompressorPage> createState() => CompressorPageState();
}

class CompressorPageState extends State<CompressorPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _mics = [];
  StreamSubscription<int>? _streamSubscription;
  final StreamController<int> _streamController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataMics();
    _runBackgroundTask();
  }

  _getDataMics() async {
    await getAllMics();

    if (mounted) {
      setState(
        () => _mics = getMics(),
      );
    }
    isLoading = false;
  }

  _runBackgroundTask() async {
    _streamSubscription = Stream.periodic(const Duration(seconds: 1), (count) {
      if (tcpClient.isBroadcast && tcpClient.isCompressor) {
        _streamController.add(count);
        isLoading = true;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                const LoadingOverlay(child: CompressorPage())));
        tcpClient.isBroadcast = false;
        tcpClient.isCompressor = false;
      }
      return count;
    }).listen((count) {});
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamController.close();
    debugPrint(
        "---------------------- I QUIT THE COMPRESSOR PAGE ----------------------");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Padding> widgetCompressor = List.generate(
      _mics.length,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Column(
          children: <Widget>[
            builCompressorName(index),
            buildCompressor(index),
          ],
        ),
      ),
    );
    if (_mics.isNotEmpty && !isLoading) {
      // After loading with data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: MyAppBar(
                title: "Compressor", drawerScaffoldKey: drawerScaffoldKey),
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
                  buildCompressorScrollView(widgetCompressor),
                  buildCompressorSaveButton(),
                ],
              ),
            )),
      );
    } else if (_mics.isEmpty && !isLoading) {
      // After loading without data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: MyAppBar(
              title: "Compressor", drawerScaffoldKey: drawerScaffoldKey),
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
                    "No Compressor to load",
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
          appBar: MyAppBar(
              title: "Compressor", drawerScaffoldKey: drawerScaffoldKey),
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

  /// Widget compressor name Text
  ///
  /// @param [index] is the current index in the list
  Widget builCompressorName(int index) => Text(
        micNameList[index],
        style: const TextStyle(color: Colors.white, fontSize: 15),
      );

  /// Widget compressor
  ///
  /// @param [index] is the current index in the list
  Widget buildCompressor(int index) => Row(
        children: <Widget>[
          buildCompressorVolumeBar(index),
          buildCompressorMuteButton(index),
        ],
      );

  /// Widget compressor volume bar SizedBox
  ///
  /// @param [index] is the current index in the list
  Widget buildCompressorVolumeBar(int index) => SizedBox(
        width: 300,
        child: volumeBarList[index],
        // MyVolumeBar(
        //   level: micLevelList[index],
        //   onChange: (newVal) {
        //     setState(() {
        //       micLevelList[index] = newVal;
        //     });
        //   },
        // ),
      );

  /// Widget compressor mute button IconButton
  ///
  /// @param [index] is the current index in the list
  Widget buildCompressorMuteButton(int index) => IconButton(
        onPressed: () {
          setState(
            () {
              micClickList[index] = !micClickList[index];
            },
          );
        },
        icon: Icon((micClickList[index] == true) ? Icons.mic : Icons.mic_off),
        color: MyColor().myWhite,
      );

  /// Widget compressor scroll view SingleChildScrollView
  ///
  /// @param [widgetCompressor] is the list of Compressor
  Widget buildCompressorScrollView(List<Padding> widgetCompressor) =>
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: widgetCompressor,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 40),
            ),
          ],
        ),
      );

  /// Widget compressor save button Postioned
  Widget buildCompressorSaveButton() => Positioned.fill(
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
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          MyColor().backgroundCards),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: MyColor().myOrange, width: 1)),
                    ),
                    onPressed: () async {
                      LoadingOverlay.of(context).show();
                      await setAllMics(_mics);
                      LoadingOverlay.of(context).hide();
                    },
                    child: Text(
                      "Save changes",
                      style: TextStyle(color: MyColor().myWhite),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
}
