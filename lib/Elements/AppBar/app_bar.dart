import 'package:eip_test/Pages/login.dart';
import 'package:flutter/material.dart';
import 'package:eip_test/Tools/globals.dart' as globals;

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
        buildDisconnectButton(context),
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
  }

  /// Widget disconnect button IconButton
  ///
  /// @param [context] is the context of the Widget
  Widget buildDisconnectButton(BuildContext context) => IconButton(
        onPressed: () {
          globals.reactionlist.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        },
        icon: const Icon(Icons.switch_account),
      );

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
