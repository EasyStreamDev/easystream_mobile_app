import 'package:eip_test/Elements/AppBar/app_bar.dart';
import 'package:eip_test/Elements/SideBar/navigation_drawer.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColor().myGrey,
        appBar:
            MyAppBar(title: "Home Page", drawerScaffoldKey: drawerScaffoldKey),
        body: Scaffold(
          backgroundColor: MyColor().myGrey,
          key: drawerScaffoldKey,
          drawer: const NavigationDrawerWidget(),
          body: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 60.0),
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: MyColor().myOrange,
                          borderRadius: BorderRadius.circular(10)),
                      width: 200,
                      height: 100,
                      child: Image.asset(
                        'assets/images/logo_easystream_orange.png',
                      )),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
