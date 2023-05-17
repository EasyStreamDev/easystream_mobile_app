import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class ListReactionPage extends StatefulWidget {
  const ListReactionPage({Key? key}) : super(key: key);

  @override
  State<ListReactionPage> createState() => ListReactionPageState();
}

class ListReactionPageState extends State<ListReactionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  //TODO: Get the real variables
  static var actionName = "Hello everyone";
  static var action = "Start the live";
  static var actionParameter = "seconds : 30";
  final List<Padding> _widgetBoxListReaction = [];
  static var nbrReaction = 10;

  @override
  void initState() {
    for (int i = 0; i < nbrReaction; i++) {
      _widgetBoxListReaction.add(
        Padding(
          padding: const EdgeInsets.only(
              left: 40.0, right: 40.0, top: 15.0, bottom: 15.0),
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                debugPrint("Container Deleted");
                nbrReaction --;
                _widgetBoxListReaction.removeAt(i);
              });
            },
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
                    '$actionName $i',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    'Action: $action',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    'Parameter: $actionParameter',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    super.initState();
  }

  final List<String> popupRoutes = <String>[
    "Delete",
  ];

  List<Padding> widgetBoxListReaction = List.generate(
    nbrReaction,
    (index) => Padding(
      padding: const EdgeInsets.only(
          left: 40.0, right: 40.0, top: 15.0, bottom: 15.0),
      child: GestureDetector(
        onLongPress: () {
          debugPrint("Container Deleted");
          nbrReaction --;
        },
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
                'Action: $action',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                'Parameter: $actionParameter',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
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
        backgroundColor: MyColor().myGrey,
        appBar: AppBar(
          title: const Text("List of Reaction"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Column(children: _widgetBoxListReaction),
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 40),
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Go to Add Reaction Page
          },
          backgroundColor: MyColor().myOrange,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
