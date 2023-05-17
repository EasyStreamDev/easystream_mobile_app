import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class WordDetectionPage extends StatefulWidget {
  const WordDetectionPage({Key? key}) : super(key: key);

  @override
  State<WordDetectionPage> createState() => WordDetectionPageState();
}

class WordDetectionPageState extends State<WordDetectionPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  String? dropdownvalue = 'Turn on the live';

  var items = [
    'Turn on the live',
    'Turn off the live',
    'Change scene',
    'Show shop link',
    'Show subscription reduction',
    'Turn on the lights',
    'Turn off the lights'
  ];

  var keywords = [];

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
              Padding(
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
                    labelText: 'Keyword...',
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      keywords.add(value);
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (keywords.isNotEmpty)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemExtent: 40.0,
                    itemCount: keywords.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          keywords[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      );
                    },
                  ),
                ),
              if (keywords.isEmpty)
                const SizedBox(
                  height: 150,
                ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: DropdownButton(
                    underline: Container(
                      height: 2,
                      color: MyColor().myOrange,
                    ),
                    dropdownColor: MyColor().myGrey,
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconEnabledColor: MyColor().myOrange,
                    items: items.map((items) {
                      return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: const TextStyle(color: Colors.white),
                          ));
                    }).toList(),
                    onChanged: (String? selectedValue) {
                      setState(() {
                        dropdownvalue = selectedValue;
                        items.remove(selectedValue.toString());
                        items.insert(0, selectedValue.toString());
                      });
                    },
                  )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Save keyword and reaction to the obs server and go to Action & Reaction
          },
          backgroundColor: MyColor().myOrange,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
