# EasyStream Mobile

EasyStream for mobile is an application built in flutter connected to OBS.

## Getting Started

### Setup Flutter :
A detailed guide for multiple platforms setup could be find :
https://flutter.dev/docs/get-started/install/

### Setup Android Studio :
A detailed guide for multiple platforms setup could be find :
https://developer.android.com/studio/install

### Launching App :

1) connect your phone with adb (https://developer.android.com/studio/command-line/adb) or generate an emulator with android studio
2) go to the file "pubspec.yaml" and clic on "Pub get" to get all the dependances
3) go to the file "main.dart" and run the app with "Shift+F10"

## Project Structure

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
|	|	├──subtitle.dart				# page Subtitle
|	|	└──video_source.dart				# page VideoSource
|	├──SubPage/
|	|	├──ActionPage/
|	|	|	└──list_action.dart			# sub page List Action
|	|	|	└──worddetection.dart			# sub page WordDetection
|	|	├──ReactionPage/
|	|	|	└──add_reaction.dart			# sub page add reaction
|	|	|	└──list_reaction.dart			# sub page list reaction
|	|	├──add_subtitle.dart				# sub page add subtitle
|	|	├──add_video_source.dart			# sub page add video source
|	|	└──qr_code.dart			                # sub page qr_code
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

### Video Source :
  - link a mic to multiple video sources

## Screenshots

### Login and Home Page :
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/902d8d46-0fc3-4c0e-824d-b582f519e802" width="214" height="495">
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/ed0e7a62-1ebc-4c1e-9ff5-5f013fdab985" width="214" height="495">
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/397dd5b3-d2d0-4e09-a929-28795c97b7e0" width="214" height="495">

### Navigation Bar
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/370f5d18-4475-4e07-aca5-65b8d42260a3" width="214" height="495">

### Compressor Page :
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/f37648d8-ca3f-466c-9fb9-99889f215e68" width="214" height="495">

### Action & Reaction Page :
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/50cd655d-34ca-4f85-bbc7-134262cac6e9" width="214" height="495">

### Action & Reaction subPage :
![5 1 0- List of Reaction subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/ec6006e6-09db-44e9-9362-19268eb1bd28)
![5 1 1 - Add Reaction subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/8e13da66-9cb8-40e2-b7ff-c8292b3613bd)
![5 2 0 - List of Action subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/22345e8c-aa69-47a0-9a7c-c48a80cf3c23)
![5 2 1 - WordDetection subPage](https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/7f32cc99-fed1-43f2-acd5-8e6287b0d181)

### Subtitle Page :
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/85686af8-7f3a-441c-92ab-f7b1fc1d274a" width="214" height="495">

### Subtitle subPage :
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/baa89d90-c185-48a4-a805-718cdf9c7c39" width="214" height="495">

### Video Source Page :
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/ed67d1ae-01d0-4c0b-92e1-1a91ab754133" width="214" height="495">

### Video Source subPage :
<img src="https://github.com/EasyStreamDev/easystream_mobile_app/assets/70137982/da0e468d-d38f-4b9c-8655-82e0afedc063" width="214" height="495">
