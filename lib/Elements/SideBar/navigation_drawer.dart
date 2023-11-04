import 'package:eip_test/Elements/LoadingOverlay/loading_overlay.dart';
import 'package:eip_test/Pages/PageSideBar/action_reaction.dart';
import 'package:eip_test/Pages/PageSideBar/compressor.dart';
import 'package:eip_test/Pages/PageSideBar/subtitle.dart';
import 'package:eip_test/Pages/PageSideBar/video_source.dart';
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
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Home",
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Compressor",
              icon: Icons.mic,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Action & Reaction",
              icon: Icons.add_reaction,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Subtitle",
              icon: Icons.subtitles,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "VideoSource",
              icon: Icons.video_camera_front_outlined,
              onClicked: () => selectedItem(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget menu item Widget
  ///
  /// @param :
  /// [text] name of the page
  /// [icon] Icon of the page
  /// [onClicked] Callback to get the click
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoadingOverlay(
              child: CompressorPage(),
            ),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoadingOverlay(
              child: ActionReactionPage(),
            ),
          ),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoadingOverlay(
              child: SubtitlePage(),
            ),
          ),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoadingOverlay(
              child: VideoSource(),
            ),
          ),
        );
        break;
    }
  }
}
