import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().myGrey,
      appBar: AppBar(
        title: const Text("Home Page"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            icon: const Icon(Icons.switch_account),
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (drawerScaffoldKey.currentState!.isDrawerOpen) {
                  Navigator.pop(context);
                } else {
                  drawerScaffoldKey.currentState!.openDrawer();
                }
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Scaffold(
        backgroundColor: MyColor().myGrey,
        key: drawerScaffoldKey,
        drawer: const NavigationDrawerWidget(),
      ),
    );
  }
}