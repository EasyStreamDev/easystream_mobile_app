import 'package:eip_test/Pages/PageSideBar/micro.dart';
import 'package:eip_test/Pages/home.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:flutter/material.dart';

class MyVolumeBar extends StatefulWidget {
  const MyVolumeBar({Key? key, required this.mics}) : super(key: key);

  final List<dynamic> mics;

  @override
  State<MyVolumeBar> createState() => MyVolumeBarState();
}

class MyVolumeBarState extends State<MyVolumeBar> {
  double currentSliderValue = 23;
  
  @override
  void initState() {
    super.initState();
    currentSliderValue = widget.mics[0]["level"];
  }

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
          debugPrint('number : ${widget.mics[0]["level"]}');
        });
      },
    );
  }
}

