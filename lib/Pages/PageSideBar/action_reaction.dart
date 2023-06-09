import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/SubPage/ActionPage/list_action.dart';
import 'package:eip_test/Pages/SubPage/ReactionPage/list_reaction.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';

List<String> actionType = List.generate(100, (index) => "");
List<List<String>> actionWords =
    List.generate(100, (index) => List.generate(5, (index) => ""));
List<String> reactionType = List.generate(100, (index) => "");
List<String> reactionParams = List.generate(100, (index) => "");
int nbrActionReaction = 0;
bool isLoading = true;

Future<void> getActReactCouples() async {
  Map<String, dynamic> msg = {"command": "getActReactCouples"};

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
    List<dynamic> couples = requestResult["data"]["actReacts"];
    nbrActionReaction = requestResult["data"]["length"];
    debugPrint("nbrActionReaction : " + nbrActionReaction.toString());
    debugPrint(couples.toString());
    for (int i = 0; i < couples.length; i++) {
      actionType[i] = couples[i]["action"]["type"];
      debugPrint("actionType[" + i.toString() + "] : " + actionType[i]);
      for (int j = 0; j < couples[i]["action"]["params"]["words"].length; j++) {
        actionWords[i][j] = couples[i]["action"]["params"]["words"][j];
        debugPrint("actionWords[" +
            i.toString() +
            "][" +
            j.toString() +
            "] : " +
            actionWords[i][j]);
      }
      reactionType[i] = couples[i]["reaction"]["type"];
      debugPrint("reactionType[" + i.toString() + "] : " + reactionType[i]);
      if (reactionType[i] == "SCENE_SWITCH") {
        reactionParams[i] = couples[i]["reaction"]["params"]["scene"];
      } else if (reactionType[i] == "START_REC" ||
          reactionType[i] == "STOP_REC" ||
          reactionType[i] == "START_STREAMING" ||
          reactionType[i] == "STOP_STREAMING") {
        // reactionParams[i] = couples[i]["reaction"]["params"]["delay"].toString();
        reactionParams[i] = "";
      } else {
        reactionParams[i] = "";
      }
      debugPrint("reactionParams[" + i.toString() + "] : " + reactionParams[i]);
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

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _getDataCouples();
  }

  _getDataCouples() async {
    await getActReactCouples();

    setState(
      () => _couples = getCouples(),
    );
    isLoading = false;
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
            backgroundColor: MyColor().myGrey, // Background app
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: Stack(
              children: <Widget>[
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
            backgroundColor: MyColor().myGrey, // Background app
            key: drawerScaffoldKey,
            drawer: const NavigationDrawerWidget(),
            body: Stack(
              children: <Widget>[
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
        height: 100.0,
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
            builActionReactionActionTypeText(index),
            builActionReactionActionText(index),
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
  Widget builActionReactionActionText(int index) => RichText(
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
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListReactionPage()));
          },
          icon: const Icon(Icons.add),
          label: const Text(
            "Reaction",
          ),
        ),
      );

  /// Widget action & reaction button action SizedBox
  Widget buildActionReactionButtonAction() => SizedBox(
        width: 150.0,
        height: 50.0,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListActionPage()));
          },
          icon: const Icon(Icons.add),
          label: const Text(
            "Action",
          ),
        ),
      );
}
