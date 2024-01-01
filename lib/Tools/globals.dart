library my_prj.globals;

class Reactions {
  late String name;
  late String reaction;
  late String parameter;
}

List<Reactions> reactionlist = [];

class Subtitle {
  late String uuid;
  late int length;
  late List<String> linkedMics;
  late String language;
}

List<Subtitle> subtitlelist = [];

String subscription = "";
String ipAddress = "";
bool isConnected = false;