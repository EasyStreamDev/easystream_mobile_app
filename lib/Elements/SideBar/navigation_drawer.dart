import 'package:eip_test/Pages/PageSideBar/camera.dart';
import 'package:eip_test/Pages/PageSideBar/event.dart';
import 'package:eip_test/Pages/PageSideBar/micro.dart';
import 'package:eip_test/Pages/PageSideBar/scene.dart';
import 'package:eip_test/Pages/PageSideBar/actionreaction.dart';
import 'package:eip_test/Pages/home.dart';
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
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Microphone",
              icon: Icons.mic,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Camera",
              icon: Icons.videocam,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Scenes",
              icon: Icons.addchart,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Events",
              icon: Icons.emoji_events,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Action & Reaction",
              icon: Icons.add_reaction,
              onClicked: () => selectedItem(context, 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: MyColor().myWhite)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  selectedItem(BuildContext context, int i) {
    switch (i) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MicroPage()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CameraPage()));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScenePage()));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EventPage()));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ActionReactionPage()));
        break;
    }
  }
}
