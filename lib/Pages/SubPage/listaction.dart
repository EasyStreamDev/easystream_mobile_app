import 'package:eip_test/Styles/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../PageSideBar/event.dart';

class ListActionPage extends StatefulWidget {
  const ListActionPage({Key? key}) : super(key: key);

  @override
  State<ListActionPage> createState() => ListActionPageState();
}

class ListActionPageState extends State<ListActionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColor().myGrey,
        appBar: AppBar(
          title: const Text("List of Action"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30,bottom: 30),
                    child: Text(
                      "Select an Action :",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: RichText(
                      text: TextSpan(
                        text: 'WordDetection',
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EventPage())); //TODO: Towards WordDetection Page
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}