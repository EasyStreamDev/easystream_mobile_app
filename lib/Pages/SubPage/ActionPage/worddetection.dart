import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Pages/PageSideBar/action_reaction.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/Tools/globals.dart' as globals;

Future<void> setActionReactionSceneSwitch(List<String> actionParams,
    String reactionName, String reactionScene) async {
  Map<String, dynamic> msg = {
    "command": "setActionReaction",
    "params": {
      "action": {
        "type": "WORD_DETECT",
        "params": {"words": actionParams},
      },
      "reaction": {
        "name": reactionName,
        "type": "SCENE_SWITCH",
        "params": {"scene": reactionScene}
      }
    }
  };
  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
}

Future<void> setActionReactionToggleAudioCompressor(
    List<String> actionParams,
    String reactionName,
    String reactionAudioSourceIdentifier,
    bool reactionToggle) async {
  Map<String, dynamic> msg = {
    "command": "setActionReaction",
    "params": {
      "action": {
        "type": "WORD_DETECT",
        "params": {"words": actionParams},
      },
      "reaction": {
        "name": reactionName,
        "type": "TOGGLE_AUDIO_COMPRESSOR",
        "params": {
          "audio-source": reactionAudioSourceIdentifier,
          "toggle": reactionToggle
        }
      }
    }
  };
  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
}

Future<void> setActionReactionStartRec(
    List<String> actionParams, String reactionName, int reactionDelay) async {
  Map<String, dynamic> msg = {
    "command": "setActionReaction",
    "params": {
      "action": {
        "type": "WORD_DETECT",
        "params": {"words": actionParams},
      },
      "reaction": {
        "name": reactionName,
        "type": "START_REC",
        "params": {"delay": reactionDelay}
      }
    }
  };
  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
}

Future<void> setActionReactionStopRec(
    List<String> actionParams, String reactionName, int reactionDelay) async {
  Map<String, dynamic> msg = {
    "command": "setActionReaction",
    "params": {
      "action": {
        "type": "WORD_DETECT",
        "params": {"words": actionParams},
      },
      "reaction": {
        "name": reactionName,
        "type": "STOP_REC",
        "params": {"delay": reactionDelay}
      }
    }
  };
  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
}

Future<void> setActionReactionStartStream(
    List<String> actionParams, String reactionName, int reactionDelay) async {
  Map<String, dynamic> msg = {
    "command": "setActionReaction",
    "params": {
      "action": {
        "type": "WORD_DETECT",
        "params": {"words": actionParams},
      },
      "reaction": {
        "name": reactionName,
        "type": "START_STREAM",
        "params": {"delay": reactionDelay}
      }
    }
  };
  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
}

Future<void> setActionReactionStopStream(
    List<String> actionParams, String reactionName, int reactionDelay) async {
  Map<String, dynamic> msg = {
    "command": "setActionReaction",
    "params": {
      "action": {
        "type": "WORD_DETECT",
        "params": {"words": actionParams},
      },
      "reaction": {
        "name": reactionName,
        "type": "STOP_STREAM",
        "params": {"delay": reactionDelay}
      }
    }
  };
  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
  if (tcpClient.messages.isNotEmpty) {
    tcpClient.messages.clear();
  }
}

class WordDetectionPage extends StatefulWidget {
  const WordDetectionPage({Key? key}) : super(key: key);

  @override
  State<WordDetectionPage> createState() => WordDetectionPageState();
}

class WordDetectionPageState extends State<WordDetectionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  String _dropdownvalue = "";
  final List<String> _actionParams = [];
  final List<String> _reactionName = [];
  String _reactionType = "";
  String _reactionParams = "";
  String _reactionScene = "";
  int _reactionDelay = 0;

  @override
  void initState() {
    if (globals.reactionlist.isNotEmpty) {
      _dropdownvalue =
          globals.reactionlist[globals.reactionlist.length - 1].name;
      for (int i = 0; i < globals.reactionlist.length; i++) {
        _reactionName.add(globals.reactionlist[i].name);
      }
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
        appBar: AppBar(
          title: const Text("Word Detection"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              buildFieldInsertKeywords(),
              const SizedBox(
                height: 20,
              ),
              if (_actionParams.isNotEmpty) buildKeywordsList(),
              if (_actionParams.isEmpty) buildKeywordsListEmpty(),
              const SizedBox(
                height: 50,
              ),
              buildSelectReactionTitle(),
              buildSelectReactionDropDown(),
            ],
          ),
        ),
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  /// Widget worddetection field insert keywords Padding
  Widget buildFieldInsertKeywords() => Padding(
        // Text Field Insert Keywords
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyColor().myOrange),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: MyColor().myOrange),
            ),
            labelText: 'Insert keywords...',
            labelStyle: const TextStyle(color: Colors.white),
          ),
          onSubmitted: (value) {
            setState(
              () {
                _actionParams.add(value);
              },
            );
          },
        ),
      );

  /// Widget worddetecion list of keywords SizedBox
  Widget buildKeywordsList() => SizedBox(
        height: 150,
        child: ListView.builder(
          itemExtent: 40.0,
          itemCount: _actionParams.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "     " + _actionParams[index],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            );
          },
        ),
      );

  /// Widget worddetecion list of keywords empty SizedBox
  Widget buildKeywordsListEmpty() => const SizedBox(
        height: 150,
      );

  /// Widget worddetection select reaction title Row
  Widget buildSelectReactionTitle() => const Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select a Reaction :",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      );

  /// Widget worddetection select reaction dropdown Row
  Widget buildSelectReactionDropDown() => Row(
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
              value: _dropdownvalue,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: MyColor().myOrange,
              items: _reactionName.map(
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
                setState(
                  () {
                    _dropdownvalue = selectedValue!;
                    _reactionName.remove(
                      selectedValue.toString(),
                    );
                    _reactionName.insert(
                      0,
                      selectedValue.toString(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );

  /// Widget worddetecion floating action button FloatingActionButton
  Widget buildFloatingActionButton() => FloatingActionButton(
        onPressed: () async {
          LoadingOverlay.of(context).show();
          for (int i = 0; i < globals.reactionlist.length; i++) {
            if (globals.reactionlist[i].name == _dropdownvalue) {
              _reactionParams = globals.reactionlist[i].parameter;
              _reactionType = globals.reactionlist[i].reaction;
            }
          }
          if (_reactionType == "SCENE_SWITCH") {
            _reactionScene = _reactionParams;
            await setActionReactionSceneSwitch(
                _actionParams, _dropdownvalue, _reactionScene);
          }
          // if (_reactionType == "TOGGLE_AUDIO_COMPRESSOR") {
          //   await setActionReactionToggleAudioCompressor(_actionParams, _dropdownvalue);
          // }
          if (_reactionType == "START_REC") {
            _reactionDelay = int.parse(_reactionParams);
            await setActionReactionStartRec(
                _actionParams, _dropdownvalue, _reactionDelay);
          }
          if (_reactionType == "STOP_REC") {
            _reactionDelay = int.parse(_reactionParams);
            await setActionReactionStopRec(
                _actionParams, _dropdownvalue, _reactionDelay);
          }
          if (_reactionType == "START_STREAM") {
            _reactionDelay = int.parse(_reactionParams);
            await setActionReactionStartStream(
                _actionParams, _dropdownvalue, _reactionDelay);
          }
          if (_reactionType == "STOP_STREAM") {
            _reactionDelay = int.parse(_reactionParams);
            await setActionReactionStopStream(
                _actionParams, _dropdownvalue, _reactionDelay);
          }
          LoadingOverlay.of(context).hide();
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ActionReactionPage()));
        },
        backgroundColor: MyColor().myOrange,
        child: const Icon(Icons.save),
      );
}
