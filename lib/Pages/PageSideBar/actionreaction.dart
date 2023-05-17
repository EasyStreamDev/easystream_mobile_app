import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Pages/SubPage/listaction.dart';
import 'package:eip_test/Pages/SubPage/listreaction.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class ActionReactionPage extends StatefulWidget {
  const ActionReactionPage({Key? key}) : super(key: key);

  @override
  State<ActionReactionPage> createState() => ActionReactionPageState();
}

class ActionReactionPageState extends State<ActionReactionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  //TODO: Get the real variables
  static var actionName = "Word Detection";
  static var actionDescription = "If you say...";
  static var reactionName = "Change Camera...";
  static var nbrAction = 7;

  final List<Padding> widgetBoxActionReaction = List.generate(
    nbrAction, //TODO: Number of Action & Reaction Boxes
    (index) => Padding(
      padding: const EdgeInsets.only(
          left: 40.0, right: 40.0, top: 15.0, bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 80.0,
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
            Text(
              '$actionName ${index + 1} ',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              'Action: $actionDescription',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              'Reaction: $reactionName',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
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
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ListReactionPage()));
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Reaction"),
                          ),
                        ),
                        SizedBox(
                          width: 150.0,
                          height: 50.0,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ListActionPage()));
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Action"),
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
        ),
      ),
    );
  }
}
