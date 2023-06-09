import 'package:eip_test/Pages/SubPage/ReactionPage/list_reaction.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/Tools/globals.dart' as globals;

class AddReactionPage extends StatefulWidget {
  const AddReactionPage({Key? key}) : super(key: key);

  @override
  State<AddReactionPage> createState() => AddReactionPageState();
}

class AddReactionPageState extends State<AddReactionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  String reactionName = "";
  String reactionParameter = "";
  String dropdownReactions = 'SCENE_SWITCH';

  var reactions = [
    'SCENE_SWITCH',
    'START_REC',
    'STOP_REC',
    'START_STREAM',
    'STOP_STREAM',
    // 'TOGGLE_AUDIO_COMPRESSOR'
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColor().myGrey,
        appBar: AppBar(
          title: const Text("Add Reaction"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
              buildFieldReactionName(),
              const SizedBox(
                height: 100,
              ),
              buildSelectReactionTitle(),
              buildSelectReaction(),
              const SizedBox(
                height: 100,
              ),
              buildFieldParameterName(),
            ],
          ),
        ),
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  /// Widget field reaction name Padding
  Widget buildFieldReactionName() => Padding(
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
            labelText: 'Name of the Reaction',
            labelStyle: const TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            setState(
              () {
                reactionName = value;
              },
            );
          },
        ),
      );

  /// Widget select reaction title Row
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

  /// Widget select reaction Row
  Widget buildSelectReaction() => Row(
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
              value: dropdownReactions,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: MyColor().myOrange,
              items: reactions.map(
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
                    dropdownReactions = selectedValue!;
                    reactions.remove(
                      selectedValue.toString(),
                    );
                    reactions.insert(
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

  /// Widget field parameter name Padding
  Widget buildFieldParameterName() => Padding(
        // Field Parameter of the Reaction
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
            labelText: 'Parameter of the Reaction',
            labelStyle: const TextStyle(color: Colors.white),
          ),
          onChanged: (value) {
            setState(
              () {
                reactionParameter = value;
              },
            );
          },
        ),
      );

  /// Widget add reaction floating action button FloatingActionButton
  Widget buildFloatingActionButton() => FloatingActionButton(
        onPressed: () {
          globals.Reactions reactions = globals.Reactions();
          reactions.name = reactionName;
          reactions.reaction = dropdownReactions;
          reactions.parameter = reactionParameter;
          globals.reactionlist.add(reactions);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ListReactionPage()));
        },
        backgroundColor: MyColor().myOrange,
        child: const Icon(Icons.save),
      );
}
