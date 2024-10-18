import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';

import '../domain/entities/track_entity.dart';
import '../objectbox.g.dart';

/// Provides access to the ObjectBox Store throughout the app.
late Box<TrackEntity> trackBox;

// We will use this plugin to be able to overwrite audio files in music library with updated metadata
final mediaStorePlugin = MediaStore();

// we need to access the scaffold key from a lot of methods and widgets so we make it global
GlobalScaffoldKey globalScaffoldKey = GlobalScaffoldKey();

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
