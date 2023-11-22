import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/PageSideBar/video_source.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

List<String> micNameList = List.empty();
List<String> micUuidList = List.empty();
List<String> videoSourceNameList = List.empty();
List<String> videoSourceUuidList = List.empty();

bool isLoading = true;

Future<void> getAllMics() async {
  Map<String, dynamic> msg = {"command": "/microphones/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> getAllVideoSource() async {
  Map<String, dynamic> msg = {"command": "/display-sources/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> setVideoSource(
    String micUuid, List<String> videoSourceUuidList) async {
  Map<String, dynamic> msg = {
    "command": "/mtdsis/create",
    "params": {"mic_id": micUuid, "display_sources_ids": videoSourceUuidList},
  };
  tcpClient.sendMessage(msg);
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
    if (requestResult["data"]["mics"] == null) {
      return ([]);
    }
    List<dynamic> mics = requestResult["data"]["mics"];
    micNameList = List.generate(requestResult.length, (index) => "");
    micUuidList = List.generate(requestResult.length, (index) => "");
    for (int i = 0; i < mics.length; i++) {
      micNameList[i] = mics[i]["micName"];
      micUuidList[i] = mics[i]["uuid"];
    }
    debugPrint("mics : " + mics.toString());
    return (mics);
  }
}

List<dynamic> getVideoSource() {
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
    if (requestResult["data"]["display_sources"] == null) {
      return ([]);
    }
    List<dynamic> videoSource = requestResult["data"]["display_sources"];
    videoSourceNameList = List.generate(videoSource.length, (index) => "");
    videoSourceUuidList = List.generate(videoSource.length, (index) => "");
    for (int i = 0; i < videoSource.length; i++) {
      videoSourceNameList[i] = videoSource[i]["name"];
      videoSourceUuidList[i] = videoSource[i]["uuid"];
    }
    debugPrint("video Source : " + videoSource.toString());
    return (videoSource);
  }
}

class AddVideoSourcePage extends StatefulWidget {
  const AddVideoSourcePage({Key? key}) : super(key: key);

  @override
  State<AddVideoSourcePage> createState() => AddVideoSourcePageState();
}

class AddVideoSourcePageState extends State<AddVideoSourcePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _mics = [];
  List<dynamic> _videoSource = [];

  String dropdownVideoSource = "";
  List<String> tmpNameVideoSource = [];
  String dropdownMics = "";
  List<String> tmpNameMics = [];

  String micNameToSend = "";
  String micUuidToSend = "";
  List<String> videoSourceNameListToSend = [];
  List<String> videoSourceUuidListToSend = [];

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataMics();
    _getDataVideoSource();
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
    }
  }

  _getDataVideoSource() async {
    await getAllVideoSource();
    if (mounted) {
      setState(
        () => _videoSource = getVideoSource(),
      );
      if (_videoSource.isNotEmpty) {
        dropdownVideoSource = videoSourceNameList[0];
        for (int i = 0; i < videoSourceNameList.length; i++) {
          tmpNameVideoSource.add(videoSourceNameList[i]);
        }
      }
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoSource.isNotEmpty && !isLoading) {
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
            title: Text("Add Video Source",
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
                buildSelectMicsTitle(),
                buildSelectMics(),
                const SizedBox(
                  height: 50,
                ),
                // buildSelectVideoSourceTitle(),
                buildSelectVideoSource(),
              ],
            ),
          ),
          floatingActionButton: buildFloatingSubtitle(),
        ),
      );
    } else if (_videoSource.isEmpty && !isLoading) {
      // After loading without data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: MyColor().backgroundAppBar,
            title: Text("Add Video Source",
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
                    "No Video Source to load",
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
            title: Text("Add Video Source",
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

  /// Widget select mics title Row
  Widget buildSelectMicsTitle() => const Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select a Mic",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );

  /// Widget select mics fields Row
  Widget buildSelectMics() => Row(
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
              value: dropdownMics,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: MyColor().myOrange,
              items: tmpNameMics.map(
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
                      dropdownMics = selectedValue!;
                      micNameToSend = selectedValue;
                      tmpNameMics.remove(
                        selectedValue.toString(),
                      );
                      tmpNameMics.insert(
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

  /// Widget select video source title Row
  Widget buildSelectVideoSourceTitle() => const Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select a Video Source :",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );

  /// Widget select Video source Row
  Widget buildSelectVideoSource() => Row(
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
                items: videoSourceNameList
                    .map((videoSourceNameList) => MultiSelectItem(
                        videoSourceNameList, videoSourceNameList))
                    .toList(),
                initialValue: videoSourceNameListToSend,
                onConfirm: (values) {
                  if (mounted) {
                    setState(() {
                      videoSourceNameListToSend = values;
                    });
                  }
                },
                // style
                title: const Text(
                  "Select a Video Source",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                buttonText: const Text(
                  "Select a Video Source",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                buttonIcon: Icon(
                  Icons.keyboard_arrow_down,
                  color: MyColor().myOrange,
                ),
                backgroundColor: MyColor().myGrey,
                selectedColor: MyColor().myOrange,
                separateSelectedItems: true,
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
            int x = 0;

            if (micNameToSend.isNotEmpty && mounted) {
              for (int i = 0; i < micNameList.length; i++) {
                if (micNameList[i] == micNameToSend) {
                  micUuidToSend = micUuidList[i];
                }
              }
            }
            debugPrint("Mic name : " + micNameToSend.toString());
            debugPrint("Mic uuid : " + micUuidToSend.toString());
            videoSourceUuidListToSend =
                List.generate(videoSourceUuidList.length, (index) => "");
            if (videoSourceNameListToSend.isNotEmpty && mounted) {
              for (int i = 0; i < videoSourceNameList.length; i++) {
                for (int j = 0; j < videoSourceNameListToSend.length; j++) {
                  if (videoSourceNameListToSend[j] == videoSourceNameList[i]) {
                    videoSourceUuidListToSend[x] = videoSourceUuidList[i];
                    x++;
                  }
                }
              }
            }
            debugPrint(
                "Video Source name : " + videoSourceNameListToSend.toString());
            debugPrint(
                "Video Source uuid : " + videoSourceUuidListToSend.toString());

            LoadingOverlay.of(context).show();
            await setVideoSource(micUuidToSend, videoSourceUuidListToSend);
            LoadingOverlay.of(context).hide();
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const LoadingOverlay(child: VideoSource())));
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
