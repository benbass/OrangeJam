import 'package:flutter/material.dart';

import '../domain/entities/track_entity.dart';

GlobalScaffoldKey globalScaffoldKey = GlobalScaffoldKey();

class GlobalScaffoldKey {
  late GlobalKey _scaffoldKey;
  GlobalScaffoldKey() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

const String appName = "Trackslice";

class GlobalLists {
  static final GlobalLists _globalLists = GlobalLists._internal();
  factory GlobalLists() {
    return _globalLists;
  }
  GlobalLists._internal();
  List<TrackEntity> initialTracks = [];
  List<TrackEntity> queue = [];
}

class ValuesForPlaylistDialogs{
  static final ValuesForPlaylistDialogs _valuesForPlaylistDialogs = ValuesForPlaylistDialogs._internal();
  factory ValuesForPlaylistDialogs(){
    return _valuesForPlaylistDialogs;
  }
  ValuesForPlaylistDialogs._internal();

  String selectedVal = "";
  Map<int, String> playlistMap = {};
  List<String> playlistNames = [];
  int selectedIndex = 0;
  final TextEditingController txtController = TextEditingController();
}