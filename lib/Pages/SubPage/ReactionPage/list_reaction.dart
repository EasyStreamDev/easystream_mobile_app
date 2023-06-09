import 'package:eip_test/Pages/SubPage/ReactionPage/add_reaction.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/Tools/globals.dart' as globals;

class ListReactionPage extends StatefulWidget {
  const ListReactionPage({Key? key}) : super(key: key);

  @override
  State<ListReactionPage> createState() => ListReactionPageState();
}

class ListReactionPageState extends State<ListReactionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  final List<Padding> _widgetBoxListReaction = [];
  int nbrReaction = globals.reactionlist.length;

  @override
  void initState() {
    for (int index = 0; index < nbrReaction; index++) {
      _widgetBoxListReaction.add(
        Padding(
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
                builReactionTitle(index),
                buildReaction(index),
                buildReactionParameter(index),
              ],
            ),
          ),
        ),
      );
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
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  /// Widget reaction title RichText
  Widget builReactionTitle(int index) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: globals.reactionlist[index].name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );

  /// Widget reaction RichText
  Widget buildReaction(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Reaction: ',
            ),
            TextSpan(
              text: globals.reactionlist[index].reaction.toLowerCase(),
              style: TextStyle(
                  color: MyColor().myOrange,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  /// Widget reaction parameter RichText
  Widget buildReactionParameter(int index) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Parameter: ',
            ),
            TextSpan(
              text: globals.reactionlist[index].parameter,
              style: TextStyle(
                  color: MyColor().myOrange,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  /// Widget list reaction floating action button FloatingActionButton
  Widget buildFloatingActionButton() => FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddReactionPage()));
        },
        backgroundColor: MyColor().myOrange,
        child: const Icon(Icons.add),
      );
}
