import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyVolumeBar extends StatefulWidget {
  MyVolumeBar({Key? key, required this.level, required this.onChange}) : super(key: key);

  double level;
  // ignore: prefer_typing_uninitialized_variables
  final onChange;

  @override
  State<MyVolumeBar> createState() => MyVolumeBarState();
}

class MyVolumeBarState extends State<MyVolumeBar> {
  double currentSliderValue = 23;
  
  @override
  void initState() {
    super.initState();
    currentSliderValue = widget.level;
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
          widget.level = value;
          widget.onChange(widget.level);
        });
      },
    );
  }
}
