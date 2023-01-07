import 'package:eip_test/Pages/home.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class MyVolumeBar extends StatefulWidget {
  const MyVolumeBar({Key? key}) : super(key: key);

  @override
  State<MyVolumeBar> createState() => MyVolumeBarState();
}

class MyVolumeBarState extends State<MyVolumeBar> {
  double currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {

    return Slider(
      value: currentSliderValue,
      max: 100,
      divisions: 100,
      label: currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          currentSliderValue = value;
        });
      },
    );
  }
}

