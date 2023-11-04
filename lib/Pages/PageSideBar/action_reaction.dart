import 'dart:async';

import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/SubPage/ActionPage/list_action.dart';
import 'package:eip_test/Pages/SubPage/ReactionPage/list_reaction.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';

List<String> actionType = List.empty();
List<String> actionKeys = List.empty();
List<String> actionApps = List.empty();
List<List<String>> actionWords = [];

List<String> reactionType = List.empty();
List<String> reactionParams = List.empty();

int nbrActionReaction = 0;
bool isLoading = true;

Future<void> getActReactCouples() async {
  Map<String, dynamic> msg = {"command": "/areas/get"};

  tcpClient.sendMessage(msg);
  await Future.delayed(const Duration(seconds: 2));
}

List<dynamic> getCouples() {
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
    if (requestResult["data"]["actReacts"] == null) {
      return ([]);
    }
    List<dynamic> couples = requestResult["data"]["actReacts"];
    nbrActionReaction = requestResult["data"]["length"];
    if (nbrActionReaction == 0) {
      return ([]);
    }

    actionType = List.generate(nbrActionReaction, (index) => "");
    actionKeys = List.generate(nbrActionReaction, (index) => "");
    actionApps = List.generate(nbrActionReaction, (index) => "");
    actionWords = List.generate(nbrActionReaction, (index) => List.empty());

    reactionType = List.generate(nbrActionReaction, (index) => "");
    reactionParams = List.generate(nbrActionReaction, (index) => "");

    for (int i = 0; i < couples.length; i++) {
      actionType[i] = couples[i]["action"]["type"];
      if (actionType[i] == "WORD_DETECT") {
        actionWords[i] = List.generate(
            couples[i]["action"]["params"]["words"].length, (index) => "");
        for (int j = 0;
            j < couples[i]["action"]["params"]["words"].length;
            j++) {
          actionWords[i][j] = couples[i]["action"]["params"]["words"][j];
        }
      }
      if (actionType[i] == "KEY_PRESSED") {
        actionKeys[i] = couples[i]["action"]["params"]["key"];
      }
      if (actionType[i] == "APP_LAUNCH") {
        actionApps[i] = couples[i]["action"]["params"]["app_name"];
      }
      reactionType[i] = couples[i]["reaction"]["type"];
      if (reactionType[i] == "SCENE_SWITCH") {
        reactionParams[i] = couples[i]["reaction"]["params"]["scene"];
      } else if (reactionType[i] == "START_REC" ||
          reactionType[i] == "STOP_REC" ||
          reactionType[i] == "START_STREAMING" ||
          reactionType[i] == "STOP_STREAMING") {
        reactionParams[i] = "";
      } else {
        reactionParams[i] = "";
      }
    }
    if (couples.isEmpty) {}
    return (couples);
  }
}

class ActionReactionPage extends StatefulWidget {
  const ActionReactionPage({Key? key}) : super(key: key);

  @override
  State<ActionReactionPage> createState() => ActionReactionPageState();
}

class ActionReactionPageState extends State<ActionReactionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> _couples = [];
  StreamSubscription<int>? _streamSubscription;
  final StreamController<int> _streamController = StreamController<int>();

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataCouples();
    _runBackgroundTask();
  }

  _getDataCouples() async {
    await getActReactCouples();

    if (mounted) {
      setState(
        () => _couples = getCouples(),
      );
    }
    isLoading = false;
  }

  _runBackgroundTask() async {
    _streamSubscription = Stream.periodic(const Duration(seconds: 1), (count) {
      if (tcpClient.isBroadcast && tcpClient.isArea) {
        _streamController.add(count);
        isLoading = true;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                const LoadingOverlay(child: ActionReactionPage())));
        tcpClient.isBroadcast = false;
        tcpClient.isArea = false;
      }
      return count;
    }).listen((count) {});
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamController.close();
    debugPrint(
        "---------------------- I QUIT THE ACTION REACTION PAGE ----------------------");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Padding> widgetBoxActionReaction = List.generate(
      nbrActionReaction,
      (index) => Padding(
        padding: const EdgeInsets.only(
            left: 40.0, right: 40.0, top: 15.0, bottom: 15.0),
        child: buildActionReaction(index),
      ),
    );
    if (_couples.isNotEmpty && !isLoading) {
      // After Loading with data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: MyAppBar(
              title: "Action & Reaction", drawerScaffoldKey: drawerScaffoldKey),
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
                buildActionReactionBoxScrollView(widgetBoxActionReaction),
                buildActionReactionBottomButton(),
              ],
            ),
          ),
        ),
      );
    } else if (_couples.isEmpty && !isLoading) {
      // After Loading with no data
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: MyAppBar(
              title: "Action & Reaction", drawerScaffoldKey: drawerScaffoldKey),
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
                    "No Action & Reaction to load",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                buildActionReactionBottomButton(),
              ],
            ),
          ),
        ),
      );
    } else {
      //Loading
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: MyColor().myGrey,
          appBar: MyAppBar(
              title: "Action & Reaction", drawerScaffoldKey: drawerScaffoldKey),
          body: Scaffold(
            backgroundColor: MyColor().myGrey,
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: Stack(
              children: [
                Divider(
                  height: 1,
                  color: MyColor().myOrange,
                  thickness: 1,
                ),
                const Center(child: CircularProgressIndicator()),
                buildActionReactionBottomButton(),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// Widget action & reaction Container
  ///
  /// @param [index] is the current index in the list
  Widget buildActionReaction(int index) => Container(
        padding: const EdgeInsets.all(10.0),
        height: 80.0,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: MyColor().backgroundCards,
          border: Border.all(
            color: MyColor().myOrange,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          children: <Widget>[
            builActionReactionActionTypeText(index),
            if (actionType[index] == "WORD_DETECT")
              builActionReactionActionWordsText(index),
            if (actionType[index] == "KEY_PRESSED")
              builActionReactionActionKeyText(index),
            if (actionType[index] == "APP_LAUNCH")
              builActionReactionActionAppText(index),
            builActionReactionReactionText(index),
          ],
        ),
      );

  /// Widget action & reaction action type RichText
  ///
  /// @param [index] is the current index in the list
  Widget builActionReactionActionTypeText(int index) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${actionType[index]} ${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      );

  /// Widget action & reaction action RichText
  ///
  /// @param [index] is the current index in the list
  Widget builActionReactionActionWordsText(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Action: ',
            ),
            const TextSpan(text: "if you say : "),
            for (int i = 0; i < actionWords[index].length; i++)
              TextSpan(
                text: actionWords[index][i] + ' ',
                style: TextStyle(
                    color: MyColor().myOrange,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      );

  /// Widget action & reaction action RichText
  ///
  /// @param [index] is the current index in the list
  Widget builActionReactionActionKeyText(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Action: ',
            ),
            const TextSpan(text: "if you press : "),
            TextSpan(
              text: actionKeys[index] + ' ',
              style: TextStyle(
                  color: MyColor().myOrange,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  /// Widget action & reaction action RichText
  ///
  /// @param [index] is the current index in the list
  Widget builActionReactionActionAppText(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Action: ',
            ),
            const TextSpan(text: "if you launch : "),
            TextSpan(
              text: actionApps[index] + ' ',
              style: TextStyle(
                  color: MyColor().myOrange,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  /// Widget action & reaction reaction RichText
  ///
  /// @param [index] is the current index in the list
  Widget builActionReactionReactionText(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Reaction: ',
            ),
            TextSpan(
              text: reactionType[index],
              style: TextStyle(
                  color: MyColor().myOrange,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            if (reactionType[index] == "SCENE_SWITCH")
              const TextSpan(
                text: " : ",
              ),
            if (reactionType[index] == "SCENE_SWITCH")
              TextSpan(
                text: reactionParams[index],
                style: TextStyle(
                    color: MyColor().myOrange,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      );

  /// Widget action & reaction box scroll view SingleChildScrollView
  ///
  /// @param [widgetBoxActionReaction] is the list of Action & Reaction
  Widget buildActionReactionBoxScrollView(
          List<Padding> widgetBoxActionReaction) =>
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: widgetBoxActionReaction,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 40),
            )
          ],
        ),
      );

  /// Widget action & reaction bottom button Positioned
  Widget buildActionReactionBottomButton() => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(height: 12),
                buildActionReactionButtonReaction(),
                buildActionReactionButtonAction(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );

  /// Widget action & reaction button reaction SizedBox
  Widget buildActionReactionButtonReaction() => SizedBox(
        width: 150.0,
        height: 50.0,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.add,
            color: MyColor().myWhite,
          ),
          label: Text(
            "Reaction",
            style: TextStyle(color: MyColor().myWhite),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(MyColor().backgroundCards),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: MyColor().myOrange, width: 1)),
          ),
          onPressed: () {
            _streamSubscription?.cancel();
            _streamController.close();
            debugPrint(
                "---------------------- I QUIT THE ACTION REACTION PAGE ----------------------");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListReactionPage()));
          },
        ),
      );

  /// Widget action & reaction button action SizedBox
  Widget buildActionReactionButtonAction() => SizedBox(
        width: 150.0,
        height: 50.0,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.add,
            color: MyColor().myWhite,
          ),
          label: Text(
            "Action",
            style: TextStyle(color: MyColor().myWhite),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(MyColor().backgroundCards),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: MyColor().myOrange, width: 1)),
          ),
          onPressed: () {
            _streamSubscription?.cancel();
            _streamController.close();
            debugPrint(
                "---------------------- I QUIT THE ACTION REACTION PAGE ----------------------");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListActionPage()));
          },
        ),
      );
}
