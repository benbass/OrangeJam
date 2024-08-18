import 'package:flutter/material.dart';

import '../domain/entities/track_entity.dart';

GlobalScaffoldKey globalScaffoldKey = GlobalScaffoldKey();

// we need to access the scaffold key from a lot of methods and wigets so we make it global
class GlobalScaffoldKey {
  late GlobalKey _scaffoldKey;
  GlobalScaffoldKey() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

const String appName = "OrangeJam";

// we save the tracklist and make it globally accessible
class GlobalLists {
  static final GlobalLists _globalLists = GlobalLists._internal();
  factory GlobalLists() {
    return _globalLists;
  }
  GlobalLists._internal();
  List<TrackEntity> initialTracks = [];
  List<TrackEntity> queue = [];
}

// we save the playlists' names and the currently selected playlist and make all this globally accessible
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
