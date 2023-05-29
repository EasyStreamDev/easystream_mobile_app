import 'package:eip_test/Pages/SubPage/ReactionPage/listreaction.dart';
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
              Padding( // Field Name of the Reaction
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor().myOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: MyColor().myOrange),
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
              ),
              const SizedBox(
                height: 100,
              ),
              const Row( // Select a Reaction
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
              ),
              Row( // Field Dropdown Select a Reaction
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
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
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
              ),
              const SizedBox(
                height: 100,
              ),
              Padding( // Field Parameter of the Reaction
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor().myOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: MyColor().myOrange),
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
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            globals.Reactions reactions = globals.Reactions();
            reactions.name = reactionName;
            reactions.reaction = dropdownReactions;
            reactions.parameter = reactionParameter;
            globals.reactionlist.add(reactions);
            for (int i = 0; i < globals.reactionlist.length; i ++) {
              debugPrint("----------");
              debugPrint(globals.reactionlist[i].name);
              debugPrint(globals.reactionlist[i].reaction);
              debugPrint(globals.reactionlist[i].parameter);
              debugPrint("----------");
            }
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListReactionPage()));
          },
          backgroundColor: MyColor().myOrange,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
