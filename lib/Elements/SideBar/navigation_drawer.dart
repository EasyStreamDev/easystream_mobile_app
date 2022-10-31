import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const NavigationDrawerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: MyColor().myGrey,
        child: ListView (
          children: <Widget>[
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Home",
              icon: Icons.home,
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Microphone",
              icon: Icons.mic,
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Camera",
              icon: Icons.videocam,
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Scenes",
              icon: Icons.addchart,
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Events",
              icon: Icons.emoji_events,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: MyColor().myWhite)),
      hoverColor: hoverColor,
      onTap: () {},
    );
  }
}
