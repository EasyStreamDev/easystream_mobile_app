# EasyStream Mobile

EasyStream for mobile is an application built in flutter connected to OBS.

## Getting Started

### Setup Flutter :
A detailed guide for multiple platforms setup could be find :
https://flutter.dev/docs/get-started/install/

## Project Strucure

```
mobile-app/lib/
├──Client/
|	└──client_socket.dart					# socket connection OBS
|	└──client_server.dart					# connection server
├──Elements
|	├──AppBar/
|	|	└──app_bar.dart					# custom app bar
|	├──LoadingOverlay/
|	|	└──loading_overlay.dart				# custom loading circular indicator
|	├──SideBar/
|	|	└──navigation_drawer.dart			# custom navigation side bar
|	└──VolumeBar/
|		└──volume_bar.dart				# custom volume bar
├──Pages/
|	├──PageSideBar/
|	|	├──action_reaction.dart				# page Action & Reaction
|	|	├──compressor.dart				# page Compressor
|	|	└──subtitle.dart				# page Subtitle
|	├──SubPage/
|	|	├──ActionPage/
|	|	|	└──list_action.dart			# sub page List Action
|	|	|	└──worddetection.dart			# sub page WordDetection
|	|	├──ReactionPage/
|	|	|	└──add_reaction.dart			# sub page add reaction
|	|	|	└──list_reaction.dart			# sub page list reaction
|	|	└──add_subtitle.dart				# sub page add subtitle
|	├──home.dart						# page Home
|	└──login.dart						# page Login
├──Styles/
|	└──color.dart						# colors of the app
├──Tools/
|	├──color_tool.dart					# tool apply color
|	└──globals.dart						# tool variable globals
└──main.dart							# <3 of the app
```

## Features

### Compressor :
  - Change the compressor volume
  - Mute and unmute the compressor

### Action & Reaction :
  - create reaction with a name, the reaction and a parameter
  - link the created reaction to an action

### Subtitle :
  - activate subtitles on a text field

## Screenshots

### Login and Home Page :
![1 - Login Page](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/c408d9cb-b971-411f-a65b-ae8ed46a8e4c)
![2 - Home Page](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/5a443532-30e7-479d-9e7e-58bd0873150a)
![3 - Navigation side bar](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/6cd3d001-d31d-4f94-9522-fff12de7cd4d)

### Compressor Page :
![4 - Compressor Page](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/7b23c117-ca61-44b1-bee8-2e33c98961a9)

### Action & Reaction Page :
![5 0 0 - Action   Reaction Page](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/db9b029b-3156-4eb4-a4b9-1c68d592f7c8)

### Action & Reaction subPage :
![5 1 0- List of Reaction subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/ec6006e6-09db-44e9-9362-19268eb1bd28)
![5 1 1 - Add Reaction subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/8e13da66-9cb8-40e2-b7ff-c8292b3613bd)
![5 2 0 - List of Action subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/22345e8c-aa69-47a0-9a7c-c48a80cf3c23)
![5 2 1 - WordDetection subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/7f32cc99-fed1-43f2-acd5-8e6287b0d181)

### Subtitle Page :
![6 0 - Subtitle Page](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/4608edb6-0c34-4d35-b319-f7a64055bb55)

### Subtitle subPage :
![6 1 - Subtitle subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/3a76c7b6-b2af-4e40-9b7c-fa1ff33663dc)
