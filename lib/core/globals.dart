import 'package:flutter/material.dart';

GlobalScaffoldKey globalScaffoldKey = GlobalScaffoldKey();

class GlobalScaffoldKey {
  late GlobalKey _scaffoldKey;
  GlobalScaffoldKey() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}