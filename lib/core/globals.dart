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

const String appName = "OrangeJam";

class GlobalLists {
  static final GlobalLists _globalLists = GlobalLists._internal();
  factory GlobalLists() {
    return _globalLists;
  }
  GlobalLists._internal();
  List<TrackEntity> initialTracks = [];
  List<TrackEntity> queue = [];
}

class PlaylistsNamesAndSelectedVars {
  static final PlaylistsNamesAndSelectedVars _playlistsNamesAndSelectedVars =
      PlaylistsNamesAndSelectedVars._internal();
  factory PlaylistsNamesAndSelectedVars() {
    return _playlistsNamesAndSelectedVars;
  }
  PlaylistsNamesAndSelectedVars._internal();

  String selectedVal = "";
  Map<int, String> playlistMap = {};
  List<String> playlistNames = [];
  int selectedIndex = 0;
  // we use a single instance of TextEditingController for the playlist_handler methods
  // and the dialog dialogCreatePlaylist()
  final TextEditingController txtController = TextEditingController();
}
