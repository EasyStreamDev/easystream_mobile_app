import 'package:eip_test/Pages/home.dart';
import 'package:eip_test/Pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> drawerScaffoldKey;
  final String title;

  const MyAppBar({
    Key? key,
    required this.title,
    required this.drawerScaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const LoginPage()),
            );
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
    );
    throw UnimplementedError();
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

}

