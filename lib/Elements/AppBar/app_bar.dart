import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Pages/login.dart';
import 'package:eip_test/Styles/color.dart';
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
      elevation: 0,
      backgroundColor: MyColor().backgroundAppBar ,
      title: Text(
        title,
        style: TextStyle(color: MyColor().myWhite)
        ),
      automaticallyImplyLeading: false,
      actions: [
        buildDisconnectButton(context),
      ],
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            color: MyColor().myWhite,
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
        icon: const Icon(Icons.switch_account),
        color: MyColor().myWhite,
        onPressed: () {
          globals.reactionlist.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoadingOverlay(
                child: LoginPage(),
              ),
            ),
          );
        },
      );

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
